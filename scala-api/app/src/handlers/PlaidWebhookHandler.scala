package app.handlers

import app.repositories.PlaidItemRepository
import app.services.PlaidSyncService
import app.utils.logger.Logger
import ox.*
import upickle.default.ReadWriter
import upickle.default.read

case class PlaidTransactionsSyncUpdatesAvailable(
    webhook_type: String,
    webhook_code: String,
    item_id: String,
    initial_update_complete: Boolean,
    historical_update_complete: Boolean,
    environment: String
) derives ReadWriter

object PlaidWebhookHandler:
  def handleWebhook(rawJson: String): Either[Unit, String] =
    val json = ujson.read(rawJson)

    val webhookType = json("webhook_type").strOpt
    val webhookCode = json("webhook_code").strOpt

    Logger.root.warn("Not verifying Plaid webhook signature")
    Logger.root.info(s"Raw JSON: $rawJson")
    Logger.root.info(f"Webhook type: $webhookType")
    Logger.root.info(f"Webhook code: $webhookCode")

    (webhookType, webhookCode) match
      case (Some("TRANSACTIONS"), Some("SYNC_UPDATES_AVAILABLE")) =>
        Logger.root.info("Received Plaid webhook for transactions")

        supervised {
          forkUser {
            val event = read[PlaidTransactionsSyncUpdatesAvailable](json)
            PlaidItemRepository
              .getByItemId(itemId = event.item_id)
              .map(plaidItem => PlaidSyncService.syncTransactionsAndAccounts(itemId = plaidItem.id))
          }
        }

        Right("Received Plaid webhook for transactions")
      case _ =>
        Logger.root.warn(f"Not handling Plaid webhook: $webhookType, $webhookCode")
        Right("Not handling Plaid webhook")
