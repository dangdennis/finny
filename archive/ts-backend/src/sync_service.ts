import { Brand } from "effect";
import { Db } from "./db";
import { Transaction, RemovedTransaction, PlaidApi } from "plaid";
import { accountsTable, plaidItemsTable, transactionsTable } from "./schema";
import { eq, sql } from "drizzle-orm";

type ItemId = string & Brand.Brand<"ItemId">;

export const ItemId = Brand.nominal<ItemId>();

export class SyncService {
  static async syncAccountsAndTransactions(
    db: Db,
    plaidClient: PlaidApi,
    itemId: ItemId,
  ): Promise<void> {
    const item = await db.query.plaidItemsTable.findFirst({
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

    const plaidAccounts = await plaidClient.accountsGet({
      access_token: item.plaid_access_token,
    })

    await Promise.all(plaidAccounts.data.accounts.map(async (account) => {
      return db.insert(accountsTable)
        .values({
          user_id: item.user_id,
          item_id: itemId,
          plaid_account_id: account.account_id,
          name: account.name,
          mask: account.mask,
          official_name: account.official_name,
          current_balance: account.balances.current ?? 0,
          available_balance: account.balances.available ?? 0,
          iso_currency_code: account.balances.iso_currency_code,
          unofficial_currency_code: account.balances.unofficial_currency_code,
          type: account.type,
          subtype: account.subtype,
        })
        .onConflictDoUpdate({
          target: accountsTable.plaid_account_id, set: {
            current_balance: account.balances.current ?? undefined,
            available_balance: account.balances.available ?? undefined,
          }
        })
        .execute();
    }))

    const transactions = addedTransactions.concat(modifiedTransactions);

    await Promise.all(transactions.map(async (transaction) => {
      const accountDb = await db.query.accountsTable.findFirst({
        where: (accounts, { eq }) => eq(accounts.plaid_account_id, transaction.account_id),
      })

      if (!accountDb) {
        throw new Error(`Cannot find account with plaid account id ${transaction.account_id}`);
      }


      return await db.insert(transactionsTable)
        .values({
          account_id: accountDb.id,
          plaid_transaction_id: transaction.transaction_id,
          category: transaction.personal_finance_category?.primary,
          subcategory: transaction.personal_finance_category?.detailed,
          type: transaction.payment_channel,
          name: transaction.name,
          amount: transaction.amount,
          iso_currency_code: transaction.iso_currency_code,
          unofficial_currency_code: transaction.unofficial_currency_code,
          date: transaction.date,
          pending: transaction.pending,
          account_owner: transaction.account_owner,
        }).onConflictDoUpdate({
          target: transactionsTable.plaid_transaction_id,
          set: {
            category: transaction.personal_finance_category?.primary,
            subcategory: transaction.personal_finance_category?.detailed,
            type: transaction.payment_channel,
            name: transaction.name,
            amount: transaction.amount,
            iso_currency_code: transaction.iso_currency_code,
            unofficial_currency_code: transaction.unofficial_currency_code,
            date: transaction.date,
            pending: transaction.pending,
            account_owner: transaction.account_owner,
          }
        }).execute()
    }))

    await db.delete(transactionsTable)
      .where(sql`${transactionsTable.plaid_transaction_id} IN (${removedTransactions.map(t => t.transaction_id).join(",")})`)
      .execute();

    await db.update(plaidItemsTable)
      .set({ transactions_cursor: cursor })
      .where(eq(plaidItemsTable.id, itemId.valueOf()))
      .execute();
  }
}
