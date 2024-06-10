-- CreateTable
CREATE TABLE "public"."accounts" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "item_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "plaid_account_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "mask" TEXT,
    "official_name" TEXT,
    "current_balance" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "available_balance" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "iso_currency_code" TEXT,
    "unofficial_currency_code" TEXT,
    "type" TEXT,
    "subtype" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."assets" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID NOT NULL,
    "value" DOUBLE PRECISION NOT NULL,
    "description" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "assets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."goals" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "target_date" TIMESTAMPTZ(6) NOT NULL,
    "user_id" UUID NOT NULL,
    "progress" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "goals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."plaid_api_events" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "item_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "plaid_method" TEXT NOT NULL,
    "arguments" TEXT,
    "request_id" TEXT,
    "error_type" TEXT,
    "error_code" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "plaid_api_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."plaid_items" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID NOT NULL,
    "plaid_access_token" TEXT NOT NULL,
    "plaid_item_id" TEXT NOT NULL,
    "plaid_institution_id" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "transactions_cursor" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "plaid_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."plaid_link_events" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "type" TEXT NOT NULL,
    "user_id" UUID NOT NULL,
    "link_session_id" TEXT,
    "request_id" TEXT,
    "error_type" TEXT,
    "error_code" TEXT,
    "status" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "plaid_link_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."transactions" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "account_id" UUID NOT NULL,
    "plaid_transaction_id" TEXT NOT NULL,
    "category" TEXT,
    "subcategory" TEXT,
    "type" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "iso_currency_code" TEXT,
    "unofficial_currency_code" TEXT,
    "date" DATE NOT NULL,
    "pending" BOOLEAN NOT NULL,
    "account_owner" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."profiles" (
    "id" UUID NOT NULL,

    CONSTRAINT "profiles_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "uq:accounts.plaid_account_id" ON "public"."accounts"("plaid_account_id");

-- CreateIndex
CREATE INDEX "ix:accounts.user_id" ON "public"."accounts"("user_id");

-- CreateIndex
CREATE INDEX "ix:assets.user_id" ON "public"."assets"("user_id");

-- CreateIndex
CREATE INDEX "ix:goals.user_id" ON "public"."goals"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq:plaid_api_events.request_id" ON "public"."plaid_api_events"("request_id");

-- CreateIndex
CREATE INDEX "ix:plaid_api_events.item_id" ON "public"."plaid_api_events"("item_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq:plaid_items.plaid_access_token" ON "public"."plaid_items"("plaid_access_token");

-- CreateIndex
CREATE UNIQUE INDEX "uq:plaid_items.plaid_item_id" ON "public"."plaid_items"("plaid_item_id");

-- CreateIndex
CREATE INDEX "ix:plaid_items.user_id" ON "public"."plaid_items"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq:plaid_link_events.request_id" ON "public"."plaid_link_events"("request_id");

-- CreateIndex
CREATE INDEX "ix:plaid_link_events.user_id" ON "public"."plaid_link_events"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq:transactions.plaid_transaction_id" ON "public"."transactions"("plaid_transaction_id");

-- CreateIndex
CREATE INDEX "ix:transactions.account_id" ON "public"."transactions"("account_id");

-- AddForeignKey
ALTER TABLE "public"."accounts" ADD CONSTRAINT "accounts_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "public"."plaid_items"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."accounts" ADD CONSTRAINT "accounts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."assets" ADD CONSTRAINT "assets_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."goals" ADD CONSTRAINT "goals_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."plaid_api_events" ADD CONSTRAINT "plaid_api_events_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "public"."plaid_items"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."plaid_api_events" ADD CONSTRAINT "plaid_api_events_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."plaid_items" ADD CONSTRAINT "plaid_items_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."plaid_link_events" ADD CONSTRAINT "plaid_link_events_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."transactions" ADD CONSTRAINT "transactions_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

create function public.handle_new_user()
returns trigger as $$
begin
  insert into public."profiles" (id)
  values (new.id);
  return new;
end;
$$ language plpgsql security definer;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

alter table public.accounts enable row level security;
alter table public.assets enable row level security;
alter table public.goals enable row level security;
alter table public.plaid_api_events enable row level security;
alter table public.plaid_items enable row level security;
alter table public.plaid_link_events enable row level security;
alter table public.transactions enable row level security;
alter table public.profiles enable row level security;
