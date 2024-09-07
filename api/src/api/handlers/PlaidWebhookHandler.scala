package api.handlers

import api.common.*
import api.jobs.Jobs
import api.repositories.PlaidItemRepository
import io.circe.*
import io.circe.generic.auto.*
import io.circe.parser.*

case class EventPlaidTransactionsSyncUpdatesAvailable(
    webhook_type: String,
    webhook_code: String,
    item_id: String,
    initial_update_complete: Boolean,
    historical_update_complete: Boolean,
    environment: String
)

case class EventPlaidInvestmentHoldingsDefaultUpdate(
    webhook_type: String,
    webhook_code: String,
    item_id: String,
    error: Option[WebhookPlaidError],
    new_holdings: Int,
    updated_holdings: Int,
    environment: String
)

case class WebhookPlaidError(
    error_type: String,
    error_code: String,
    error_message: String,
    display_message: String,
    request_id: String,
    // causes: List[Any], // todo: figure out the data model for this
    documentation_url: String,
    suggested_action: String
)

object PlaidWebhookHandler:
  def handleWebhook(rawJson: String): Either[Unit, String] =
    parse(rawJson) match
      case Left(failure) =>
        Logger.root.error(s"Failed to parse JSON: $failure")
        Right("Failed to parse JSON")

      case Right(json) =>
        val webhookType =
          json.hcursor.downField("webhook_type").as[String].toOption
        val webhookCode =
          json.hcursor.downField("webhook_code").as[String].toOption

        Logger.root.warn("Not verifying Plaid webhook signature")
        Logger.root.info(s"Raw Plaid webhook: ${json.noSpaces}")

        (webhookType, webhookCode) match
          case (Some("TRANSACTIONS"), Some("SYNC_UPDATES_AVAILABLE")) =>
            json.as[EventPlaidTransactionsSyncUpdatesAvailable] match
              case Left(failure) =>
                Logger.root.error(s"Failed to decode JSON: $failure")
                Right("Failed to decode JSON")

              case Right(event) =>
                PlaidItemRepository
                  .getByItemId(itemId = event.item_id)
                  .map { plaidItem =>
                    (
                      event.historical_update_complete,
                      event.initial_update_complete
                    ) match
                      case (true, true) =>
                        Logger.root.info("Plaid webhook: regular update")
                        Jobs.enqueueJob(
                          Jobs.JobRequest
                            .JobSyncPlaidItem(
                              itemId = plaidItem.id.toUUID,
                              syncType = Jobs.SyncType.Default,
                              environment = event.environment
                            )
                        )
                      case (true, false) =>
                        Logger.root.info(
                          "Plaid webhook: historical update complete"
                        )
                        Jobs.enqueueJob(
                          Jobs.JobRequest
                            .JobSyncPlaidItem(
                              itemId = plaidItem.id.toUUID,
                              syncType = Jobs.SyncType.Historical,
                              environment = event.environment
                            )
                        )
                      case (false, true) =>
                        Logger.root.info(
                          "Plaid webhook: initial update complete"
                        )
                        Jobs.enqueueJob(
                          Jobs.JobRequest
                            .JobSyncPlaidItem(
                              itemId = plaidItem.id.toUUID,
                              syncType = Jobs.SyncType.Initial,
                              environment = event.environment
                            )
                        )
                      case (false, false) =>
                        Logger.root.error("Plaid webhook: no updates complete")
                  }
                Right("Handled Plaid webhook")
          case (Some("HOLDINGS"), Some("DEFAULT_UPDATE")) =>
            json.as[EventPlaidInvestmentHoldingsDefaultUpdate] match
              case Left(failure) =>
                Logger.root.error(s"Failed to decode JSON: $failure")
                Right("Failed to decode JSON")
              case Right(event) =>
                PlaidItemRepository
                  .getByItemId(itemId = event.item_id)
                  .map { plaidItem =>
                    Jobs.enqueueJob(
                      Jobs.JobRequest
                        .JobSyncPlaidItem(
                          itemId = plaidItem.id.toUUID,
                          syncType = Jobs.SyncType.Default,
                          environment = event.environment
                        )
                    )
                  }
                Right("Handled Plaid webhook")
          case _ =>
            Logger.root.warn(
              f"Not handling Plaid webhook: $webhookType, $webhookCode"
            )
            Right("Not handling Plaid webhook")
