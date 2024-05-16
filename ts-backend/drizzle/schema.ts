import { relations } from "drizzle-orm/relations";
import { pgTable, unique, uuid, text, timestamp, index, doublePrecision, date, boolean } from "drizzle-orm/pg-core"

export const users = pgTable("users", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    email: text("email").notNull(),
    password_hash: text("password_hash"),
    apple_sub: text("apple_sub"),
    created_at: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
    updated_at: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
    deleted_at: timestamp("deleted_at", { withTimezone: true }),
},
    (table) => {
        return {
            ixEmail: unique("ix:users.email").on(table.email),
            uqAppleSub: unique("uq:users.apple_sub").on(table.apple_sub),
        }
    });

export const plaidItems = pgTable("plaid_items", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    user_id: uuid("user_id").notNull().references(() => users.id),
    plaid_access_token: text("plaid_access_token").notNull(),
    plaid_item_id: text("plaid_item_id").notNull(),
    plaid_institution_id: text("plaid_institution_id").notNull(),
    status: text("status").notNull(),
    transactions_cursor: text("transactions_cursor"),
    created_at: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
    updated_at: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
    deleted_at: timestamp("deleted_at", { withTimezone: true }),
},
    (table) => {
        return {
            ixUserId: index("ix:plaid_items.user_id").on(table.user_id),
            uqPlaidAccessToken: unique("uq:plaid_items.plaid_access_token").on(table.plaid_access_token),
            uqPlaidItemId: unique("uq:plaid_items.plaid_item_id").on(table.plaid_item_id),
        }
    });

export const assets = pgTable("assets", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    user_id: uuid("user_id").notNull().references(() => users.id),
    value: doublePrecision("value").notNull(),
    description: text("description").notNull(),
    created_at: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
    updated_at: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
    deleted_at: timestamp("deleted_at", { withTimezone: true }),
},
    (table) => {
        return {
            ixUserId: index("ix:assets.user_id").on(table.user_id),
        }
    });

export const accounts = pgTable("accounts", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    item_id: uuid("item_id").notNull().references(() => plaidItems.id),
    user_id: uuid("user_id").notNull().references(() => users.id),
    plaid_account_id: text("plaid_account_id").notNull(),
    name: text("name").notNull(),
    mask: text("mask"),
    official_name: text("official_name"),
    current_balance: doublePrecision("current_balance").notNull(),
    available_balance: doublePrecision("available_balance").notNull(),
    iso_currency_code: text("iso_currency_code"),
    unofficial_currency_code: text("unofficial_currency_code"),
    type: text("type"),
    subtype: text("subtype"),
    created_at: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
    updated_at: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
    deleted_at: timestamp("deleted_at", { withTimezone: true }),
},
    (table) => {
        return {
            ixUserId: index("ix:accounts.user_id").on(table.user_id),
            uqPlaidAccountId: unique("uq:accounts.plaid_account_id").on(table.plaid_account_id),
        }
    });

export const transactions = pgTable("transactions", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    account_id: uuid("account_id").notNull().references(() => accounts.id),
    plaid_transaction_id: text("plaid_transaction_id").notNull(),
    category: text("category"),
    subcategory: text("subcategory"),
    type: text("type").notNull(),
    name: text("name").notNull(),
    amount: doublePrecision("amount").notNull(),
    iso_currency_code: text("iso_currency_code"),
    unofficial_currency_code: text("unofficial_currency_code"),
    date: date("date").notNull(),
    pending: boolean("pending").notNull(),
    account_owner: text("account_owner"),
    created_at: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
    updated_at: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
    deleted_at: timestamp("deleted_at", { withTimezone: true }),
},
    (table) => {
        return {
            ixAccountId: index("ix:transactions.account_id").on(table.account_id),
            uqPlaidTransactionId: unique("uq:transactions.plaid_transaction_id").on(table.plaid_transaction_id),
        }
    });

export const plaidLinkEvents = pgTable("plaid_link_events", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    type: text("type").notNull(),
    user_id: uuid("user_id").notNull().references(() => users.id),
    link_session_id: text("link_session_id"),
    request_id: text("request_id"),
    error_type: text("error_type"),
    error_code: text("error_code"),
    status: text("status"),
    created_at: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
    updated_at: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
    deleted_at: timestamp("deleted_at", { withTimezone: true }),
},
    (table) => {
        return {
            ixUserId: index("ix:plaid_link_events.user_id").on(table.user_id),
            uqRequestId: unique("uq:plaid_link_events.request_id").on(table.request_id),
        }
    });

export const plaidApiEvents = pgTable("plaid_api_events", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    item_id: uuid("item_id").notNull().references(() => plaidItems.id),
    user_id: uuid("user_id").notNull().references(() => users.id),
    plaid_method: text("plaid_method").notNull(),
    arguments: text("arguments"),
    request_id: text("request_id"),
    error_type: text("error_type"),
    error_code: text("error_code"),
    created_at: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
    updated_at: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
    deleted_at: timestamp("deleted_at", { withTimezone: true }),
},
    (table) => {
        return {
            ixItemId: index("ix:plaid_api_events.item_id").on(table.item_id),
            uqRequestId: unique("uq:plaid_api_events.request_id").on(table.request_id),
        }
    });

export const goals = pgTable("goals", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    name: text("name").notNull(),
    amount: doublePrecision("amount").notNull(),
    target_date: timestamp("target_date", { withTimezone: true }).notNull(),
    user_id: uuid("user_id").notNull().references(() => users.id),
    progress: doublePrecision("progress").notNull(),
    created_at: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
    updated_at: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
    deleted_at: timestamp("deleted_at", { withTimezone: true }),
},
    (table) => {
        return {
            ixUserId: index("ix:goals.user_id").on(table.user_id),
        }
    });



export const plaidItemsRelations = relations(plaidItems, ({ one, many }) => ({
    user: one(users, {
        fields: [plaidItems.user_id],
        references: [users.id]
    }),
    accounts: many(accounts),
    plaid_api_events: many(plaidApiEvents),
}));

export const usersRelations = relations(users, ({ many }) => ({
    plaid_items: many(plaidItems),
    assets: many(assets),
    accounts: many(accounts),
    plaid_link_events: many(plaidLinkEvents),
    plaid_api_events: many(plaidApiEvents),
    goals: many(goals),
}));

export const assetsRelations = relations(assets, ({ one }) => ({
    user: one(users, {
        fields: [assets.user_id],
        references: [users.id]
    }),
}));

export const accountsRelations = relations(accounts, ({ one, many }) => ({
    plaid_item: one(plaidItems, {
        fields: [accounts.item_id],
        references: [plaidItems.id]
    }),
    user: one(users, {
        fields: [accounts.user_id],
        references: [users.id]
    }),
    transactions: many(transactions),
}));

export const transactionsRelations = relations(transactions, ({ one }) => ({
    account: one(accounts, {
        fields: [transactions.account_id],
        references: [accounts.id]
    }),
}));

export const plaidLinkEventsRelations = relations(plaidLinkEvents, ({ one }) => ({
    user: one(users, {
        fields: [plaidLinkEvents.user_id],
        references: [users.id]
    }),
}));

export const plaidApiEventsRelations = relations(plaidApiEvents, ({ one }) => ({
    plaid_item: one(plaidItems, {
        fields: [plaidApiEvents.item_id],
        references: [plaidItems.id]
    }),
    user: one(users, {
        fields: [plaidApiEvents.user_id],
        references: [users.id]
    }),
}));

export const goalsRelations = relations(goals, ({ one }) => ({
    user: one(users, {
        fields: [goals.user_id],
        references: [users.id]
    }),
}));