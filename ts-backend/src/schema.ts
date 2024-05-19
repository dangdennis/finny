import { relations } from "drizzle-orm/relations";
import { unique, uuid, text, timestamp, index, doublePrecision, date, boolean, pgSchema, pgTable } from "drizzle-orm/pg-core"

export const authSchema = pgSchema("auth");

export const usersTable = authSchema.table("users", {
    id: uuid('id').primaryKey(),
    email: text('email'),
    phone: text('phone').unique(),
    phone_confirmed_at: timestamp('phone_confirmed_at', { withTimezone: true }),
    email_confirmed_at: timestamp('email_confirmed_at', { withTimezone: true }),
})

export const profilesTable = pgTable("profiles", {
    id: uuid('id').primaryKey(),
    user_id: uuid('user_id').notNull().references(() => usersTable.id),
    first_name: text('first_name').notNull(),
    last_name: text('last_name').notNull(),
    created_at: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
    updated_at: timestamp('updated_at', { withTimezone: true }).defaultNow().notNull(),
    deleted_at: timestamp('deleted_at', { withTimezone: true }),
},
    (table) => {
        return {
            ixUserId: index("ix:profiles.user_id").on(table.user_id),
        }
    });

export const plaidItemsTable = pgTable("plaid_items", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    user_id: uuid("user_id").notNull().references(() => usersTable.id),
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

export const assetsTable = pgTable("assets", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    user_id: uuid("user_id").notNull().references(() => usersTable.id),
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

export const accountsTable = pgTable("accounts", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    item_id: uuid("item_id").notNull().references(() => plaidItemsTable.id),
    user_id: uuid("user_id").notNull().references(() => usersTable.id),
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

export const transactionsTable = pgTable("transactions", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    account_id: uuid("account_id").notNull().references(() => accountsTable.id),
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

export const plaidLinkEventsTable = pgTable("plaid_link_events", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    type: text("type").notNull(),
    user_id: uuid("user_id").notNull().references(() => usersTable.id),
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

export const plaidApiEventsTable = pgTable("plaid_api_events", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    item_id: uuid("item_id").notNull().references(() => plaidItemsTable.id),
    user_id: uuid("user_id").notNull().references(() => usersTable.id),
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

export const goalsTable = pgTable("goals", {
    id: uuid("id").defaultRandom().primaryKey().notNull(),
    name: text("name").notNull(),
    amount: doublePrecision("amount").notNull(),
    target_date: timestamp("target_date", { withTimezone: true }).notNull(),
    user_id: uuid("user_id").notNull().references(() => usersTable.id),
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



export const plaidItemsRelations = relations(plaidItemsTable, ({ one, many }) => ({
    user: one(usersTable, {
        fields: [plaidItemsTable.user_id],
        references: [usersTable.id]
    }),
    accounts: many(accountsTable),
    plaid_api_events: many(plaidApiEventsTable),
}));

export const usersRelations = relations(usersTable, ({ many }) => ({
    plaid_items: many(plaidItemsTable),
    assets: many(assetsTable),
    accounts: many(accountsTable),
    plaid_link_events: many(plaidLinkEventsTable),
    plaid_api_events: many(plaidApiEventsTable),
    goals: many(goalsTable),
}));

export const assetsRelations = relations(assetsTable, ({ one }) => ({
    user: one(usersTable, {
        fields: [assetsTable.user_id],
        references: [usersTable.id]
    }),
}));

export const accountsRelations = relations(accountsTable, ({ one, many }) => ({
    plaid_item: one(plaidItemsTable, {
        fields: [accountsTable.item_id],
        references: [plaidItemsTable.id]
    }),
    user: one(usersTable, {
        fields: [accountsTable.user_id],
        references: [usersTable.id]
    }),
    transactions: many(transactionsTable),
}));

export const transactionsRelations = relations(transactionsTable, ({ one }) => ({
    account: one(accountsTable, {
        fields: [transactionsTable.account_id],
        references: [accountsTable.id]
    }),
}));

export const plaidLinkEventsRelations = relations(plaidLinkEventsTable, ({ one }) => ({
    user: one(usersTable, {
        fields: [plaidLinkEventsTable.user_id],
        references: [usersTable.id]
    }),
}));

export const plaidApiEventsRelations = relations(plaidApiEventsTable, ({ one }) => ({
    plaid_item: one(plaidItemsTable, {
        fields: [plaidApiEventsTable.item_id],
        references: [plaidItemsTable.id]
    }),
    user: one(usersTable, {
        fields: [plaidApiEventsTable.user_id],
        references: [usersTable.id]
    }),
}));

export const goalsRelations = relations(goalsTable, ({ one }) => ({
    user: one(usersTable, {
        fields: [goalsTable.user_id],
        references: [usersTable.id]
    }),
}));

export const profilesRelations = relations(profilesTable, ({ one }) => ({
    user: one(usersTable, {
        fields: [profilesTable.user_id],
        references: [usersTable.id]
    }),
}))