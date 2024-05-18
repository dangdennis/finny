import { Brand } from "effect";
import { Db } from "./db";
import { Transaction, RemovedTransaction, PlaidApi } from "plaid";

type ItemId = string & Brand.Brand<"ItemId">;

export const ItemId = Brand.nominal<ItemId>();

export class SyncService {
  static async syncAccountsAndTransactions(
    db: Db,
    plaidClient: PlaidApi,
    itemId: ItemId,
  ): Promise<void> {
    const item = await db.query.plaidItems.findFirst({
      where: (items, { eq }) => eq(items.id, itemId.toString()),
    });

    if (!item) {
      throw new Error(
        `Cannot sync transactions. Failed to fetch item with id $itemID`,
      );
    }

    let batchSize = 100;
    let cursor = item.transactions_cursor ?? undefined;
    let hasMore = true;
    const addedTransactions: Transaction[] = [];
    const modifiedTransactions: Transaction[] = [];
    const removedTransactions: RemovedTransaction[] = [];

    while (hasMore) {
      const response = await plaidClient.transactionsSync({
        access_token: item.plaid_access_token,
        count: batchSize,
        cursor,
      });

      addedTransactions.push(...response.data.added);
      modifiedTransactions.push(...response.data.modified);
      removedTransactions.push(...response.data.removed);

      hasMore = response.data.has_more;
      cursor = response.data.next_cursor;
    }

    console.log({
      addedTransactions: addedTransactions.length,
      modifiedTransactions: modifiedTransactions.length,
      removedTransactions: removedTransactions.length,
    });

    // get all accounts
    // upsert accounts
    // upsert transactions
    // delete transactions
    // update item with new cursor
  }
}
