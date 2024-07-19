package app.handlers

import app.common.*
import app.jobs.Jobs
import app.repositories.PlaidItemRepository
import io.circe.*
import io.circe.generic.auto.*
import io.circe.parser.*

case class PlaidTransactionsSyncUpdatesAvailable(
    webhook_type: String,
    webhook_code: String,
    item_id: String,
    initial_update_complete: Boolean,
    historical_update_complete: Boolean,
    environment: String
)

object PlaidWebhookHandler:
    def handleWebhook(rawJson: String): Either[Unit, String] =
        parse(rawJson) match
            case Left(failure) =>
                Logger.root.error(s"Failed to parse JSON: $failure")
                Right("Failed to parse JSON")

            case Right(json) =>
                val webhookType = json.hcursor.downField("webhook_type").as[String].toOption
                val webhookCode = json.hcursor.downField("webhook_code").as[String].toOption

                Logger.root.warn("Not verifying Plaid webhook signature")
                Logger.root.info(s"Raw Plaid webhook: $rawJson")

                (webhookType, webhookCode) match
                    case (Some("TRANSACTIONS"), Some("SYNC_UPDATES_AVAILABLE")) =>
                        json.as[PlaidTransactionsSyncUpdatesAvailable] match
                            case Left(failure) =>
                                Logger.root.error(s"Failed to decode JSON: $failure")
                                Right("Failed to decode JSON")

                            case Right(event) =>
                                PlaidItemRepository
                                    .getByItemId(itemId = event.item_id)
                                    .map { plaidItem =>
                                        (event.historical_update_complete, event.initial_update_complete) match
                                            case (true, true) =>
                                                Logger.root.info("Plaid webhook: regular update")
                                                Jobs.enqueueJob(
                                                    Jobs.JobRequest.JobSyncPlaidItem(
                                                        itemId = plaidItem.id,
                                                        syncType = Jobs.SyncType.Default,
                                                        environment = event.environment
                                                    )
                                                )
                                            case (true, false) =>
                                                Logger.root.info("Plaid webhook: historical update complete")
                                                Jobs.enqueueJob(
                                                    Jobs.JobRequest.JobSyncPlaidItem(
                                                        itemId = plaidItem.id,
                                                        syncType = Jobs.SyncType.Historical,
                                                        environment = event.environment
                                                    )
                                                )
                                            case (false, true) =>
                                                Logger.root.info("Plaid webhook: initial update complete")
                                                Jobs.enqueueJob(
                                                    Jobs.JobRequest.JobSyncPlaidItem(
                                                        itemId = plaidItem.id,
                                                        syncType = Jobs.SyncType.Initial,
                                                        environment = event.environment
                                                    )
                                                )
                                            case (false, false) =>
                                                Logger.root.error("Plaid webhook: no updates complete")
                                    }
                                Right("Handled Plaid webhook")

                    case _ =>
                        Logger.root.warn(f"Not handling Plaid webhook: $webhookType, $webhookCode")
                        Right("Not handling Plaid webhook")
