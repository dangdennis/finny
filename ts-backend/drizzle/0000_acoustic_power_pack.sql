CREATE SCHEMA if not exists "auth";

--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "accounts" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"item_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"plaid_account_id" text NOT NULL,
	"name" text NOT NULL,
	"mask" text,
	"official_name" text,
	"current_balance" double precision NOT NULL,
	"available_balance" double precision NOT NULL,
	"iso_currency_code" text,
	"unofficial_currency_code" text,
	"type" text,
	"subtype" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "uq:accounts.plaid_account_id" UNIQUE("plaid_account_id")
);

alter table accounts enable row level security;

--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "assets" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"value" double precision NOT NULL,
	"description" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"deleted_at" timestamp with time zone
);

alter table assets enable row level security;

--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "goals" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" text NOT NULL,
	"amount" double precision NOT NULL,
	"target_date" timestamp with time zone NOT NULL,
	"user_id" uuid NOT NULL,
	"progress" double precision NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"deleted_at" timestamp with time zone
);

alter table goals enable row level security;

--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "plaid_api_events" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"item_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"plaid_method" text NOT NULL,
	"arguments" text,
	"request_id" text,
	"error_type" text,
	"error_code" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "uq:plaid_api_events.request_id" UNIQUE("request_id")
);

alter table plaid_api_events enable row level security;

--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "plaid_items" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"plaid_access_token" text NOT NULL,
	"plaid_item_id" text NOT NULL,
	"plaid_institution_id" text NOT NULL,
	"status" text NOT NULL,
	"transactions_cursor" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "uq:plaid_items.plaid_access_token" UNIQUE("plaid_access_token"),
	CONSTRAINT "uq:plaid_items.plaid_item_id" UNIQUE("plaid_item_id")
);

alter table plaid_items enable row level security;

--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "plaid_link_events" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"type" text NOT NULL,
	"user_id" uuid NOT NULL,
	"link_session_id" text,
	"request_id" text,
	"error_type" text,
	"error_code" text,
	"status" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "uq:plaid_link_events.request_id" UNIQUE("request_id")
);

alter table plaid_link_events enable row level security;

--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "profiles" (
	"id" uuid PRIMARY KEY NOT NULL,
	"first_name" text NOT NULL,
	"last_name" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"deleted_at" timestamp with time zone
);

alter table profiles enable row level security;

DO $$
BEGIN
    -- Check if the function already exists
    IF NOT EXISTS (
        SELECT 1
        FROM pg_proc
        WHERE proname = 'handle_new_user'
        AND pg_function_is_visible(oid)
    ) THEN
        -- Create the function if it does not exist
        EXECUTE 'CREATE FUNCTION public.handle_new_user() 
        RETURNS trigger 
        LANGUAGE plpgsql 
        SECURITY DEFINER 
        SET search_path = '''' 
        AS $func$ 
        BEGIN 
            INSERT INTO public.profiles (id, first_name, last_name) 
            VALUES (NEW.id, NEW.raw_user_meta_data ->> ''first_name'', NEW.raw_user_meta_data ->> ''last_name''); 
            RETURN NEW; 
        END; 
        $func$;';
    END IF;
END $$;


-- trigger the function every time a user is created
DO $$
BEGIN
    -- Check if the trigger already exists
    IF NOT EXISTS (
        SELECT 1
        FROM pg_trigger
        WHERE tgname = 'on_auth_user_created'
    ) THEN
        -- Create the trigger if it does not exist
        EXECUTE '
        CREATE TRIGGER on_auth_user_created
        AFTER INSERT ON auth.users
        FOR EACH ROW
        EXECUTE FUNCTION public.handle_new_user();';
    END IF;
END $$;


--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "transactions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"account_id" uuid NOT NULL,
	"plaid_transaction_id" text NOT NULL,
	"category" text,
	"subcategory" text,
	"type" text NOT NULL,
	"name" text NOT NULL,
	"amount" double precision NOT NULL,
	"iso_currency_code" text,
	"unofficial_currency_code" text,
	"date" date NOT NULL,
	"pending" boolean NOT NULL,
	"account_owner" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "uq:transactions.plaid_transaction_id" UNIQUE("plaid_transaction_id")
);

alter table transactions enable row level security;

--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "auth"."users" (
	"id" uuid PRIMARY KEY NOT NULL,
	"email" text,
	"phone" text,
	"phone_confirmed_at" timestamp with time zone,
	"email_confirmed_at" timestamp with time zone,
	CONSTRAINT "users_phone_unique" UNIQUE("phone")
);

--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "accounts" ADD CONSTRAINT "accounts_item_id_plaid_items_id_fk" FOREIGN KEY ("item_id") REFERENCES "public"."plaid_items"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "accounts" ADD CONSTRAINT "accounts_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assets" ADD CONSTRAINT "assets_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "goals" ADD CONSTRAINT "goals_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "plaid_api_events" ADD CONSTRAINT "plaid_api_events_item_id_plaid_items_id_fk" FOREIGN KEY ("item_id") REFERENCES "public"."plaid_items"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "plaid_api_events" ADD CONSTRAINT "plaid_api_events_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "plaid_items" ADD CONSTRAINT "plaid_items_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "plaid_link_events" ADD CONSTRAINT "plaid_link_events_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "profiles" ADD CONSTRAINT "profiles_id_users_id_fk" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "transactions" ADD CONSTRAINT "transactions_account_id_accounts_id_fk" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "ix:accounts.user_id" ON "accounts" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "ix:assets.user_id" ON "assets" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "ix:goals.user_id" ON "goals" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "ix:plaid_api_events.item_id" ON "plaid_api_events" ("item_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "ix:plaid_items.user_id" ON "plaid_items" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "ix:plaid_link_events.user_id" ON "plaid_link_events" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "ix:profiles.id" ON "profiles" ("id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "ix:transactions.account_id" ON "transactions" ("account_id");