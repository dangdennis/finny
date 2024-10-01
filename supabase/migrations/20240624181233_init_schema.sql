create table "public"."accounts" (
    "id" uuid primary key default gen_random_uuid(),
    "item_id" uuid not null,
    "user_id" uuid not null,
    "plaid_account_id" text not null,
    "name" text not null,
    "mask" text,
    "official_name" text,
    "current_balance" double precision not null default 0,
    "available_balance" double precision not null default 0,
    "iso_currency_code" text,
    "unofficial_currency_code" text,
    "type" text,
    "subtype" text,
    "created_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "updated_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "deleted_at" timestamp(6) with time zone
);


alter table "public"."accounts" enable row level security;

create table "public"."assets" (
    "id" uuid primary key default gen_random_uuid(),
    "user_id" uuid not null,
    "value" double precision not null,
    "description" text not null,
    "created_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "updated_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "deleted_at" timestamp(6) with time zone
);


alter table "public"."assets" enable row level security;

create table "public"."goals" (
    "id" uuid primary key default gen_random_uuid(),
    "name" text not null,
    "amount" double precision not null,
    "target_date" timestamp(6) with time zone not null,
    "user_id" uuid not null,
    "progress" double precision not null default 0,
    "created_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "updated_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "deleted_at" timestamp(6) with time zone
);


alter table "public"."goals" enable row level security;

create table "public"."jobs" (
    "id" uuid primary key default gen_random_uuid(),
    "status" text not null default 'PENDING'::text,
    "type" text not null,
    "payload" jsonb not null,
    "created_at" timestamp(3) without time zone not null default CURRENT_TIMESTAMP,
    "updated_at" timestamp(3) without time zone not null,
    "retry_attempts" integer not null default 0,
    "last_attempted_at" timestamp(3) without time zone,
    "error_message" text,
    "idempotency_key" text
);


create table "public"."plaid_api_events" (
    "id" uuid primary key default gen_random_uuid(),
    "item_id" uuid,
    "user_id" uuid,
    "plaid_method" text not null,
    "arguments" text,
    "request_id" text,
    "error_type" text,
    "error_code" text,
    "created_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "updated_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "deleted_at" timestamp(6) with time zone
);


alter table "public"."plaid_api_events" enable row level security;

create table "public"."plaid_items" (
    "id" uuid primary key default gen_random_uuid(),
    "user_id" uuid not null,
    "plaid_access_token" text not null,
    "plaid_item_id" text not null,
    "plaid_institution_id" text not null,
    "status" text not null,
    "transactions_cursor" text,
    "created_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "updated_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "deleted_at" timestamp(6) with time zone
);


alter table "public"."plaid_items" enable row level security;

create table "public"."plaid_link_events" (
    "id" uuid primary key default gen_random_uuid(),
    "type" text not null,
    "user_id" uuid not null,
    "link_session_id" text,
    "request_id" text,
    "error_type" text,
    "error_code" text,
    "status" text,
    "created_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "updated_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "deleted_at" timestamp(6) with time zone
);


alter table "public"."plaid_link_events" enable row level security;

create table "public"."profiles" (
    "id" uuid primary key not null
);


alter table "public"."profiles" enable row level security;

create table "public"."transactions" (
    "id" uuid primary key default gen_random_uuid(),
    "account_id" uuid not null,
    "plaid_transaction_id" text not null,
    "category" text,
    "subcategory" text,
    "type" text not null,
    "name" text not null,
    "amount" double precision not null,
    "iso_currency_code" text,
    "unofficial_currency_code" text,
    "date" date not null,
    "pending" boolean not null,
    "account_owner" text,
    "created_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "updated_at" timestamp(6) with time zone not null default CURRENT_TIMESTAMP,
    "deleted_at" timestamp(6) with time zone
);


alter table "public"."transactions" enable row level security;

CREATE INDEX "ix:accounts.user_id" ON public.accounts USING btree (user_id);

CREATE INDEX "ix:assets.user_id" ON public.assets USING btree (user_id);

CREATE INDEX "ix:goals.user_id" ON public.goals USING btree (user_id);

CREATE INDEX "ix:plaid_api_events.item_id" ON public.plaid_api_events USING btree (item_id);

CREATE INDEX "ix:plaid_api_events.user_id" ON public.plaid_api_events USING btree (user_id);

CREATE INDEX "ix:plaid_items.user_id" ON public.plaid_items USING btree (user_id);

CREATE INDEX "ix:plaid_link_events.user_id" ON public.plaid_link_events USING btree (user_id);

CREATE INDEX "ix:transactions.account_id" ON public.transactions USING btree (account_id);

CREATE UNIQUE INDEX jobs_idempotency_key_key ON public.jobs USING btree (idempotency_key);

CREATE UNIQUE INDEX "uq:accounts.plaid_account_id" ON public.accounts USING btree (plaid_account_id);

CREATE UNIQUE INDEX "uq:plaid_api_events.request_id" ON public.plaid_api_events USING btree (request_id);

CREATE UNIQUE INDEX "uq:plaid_items.plaid_access_token" ON public.plaid_items USING btree (plaid_access_token);

CREATE UNIQUE INDEX "uq:plaid_items.plaid_item_id" ON public.plaid_items USING btree (plaid_item_id);

CREATE UNIQUE INDEX "uq:plaid_link_events.request_id" ON public.plaid_link_events USING btree (request_id);

CREATE UNIQUE INDEX "uq:transactions.plaid_transaction_id" ON public.transactions USING btree (plaid_transaction_id);

alter table "public"."accounts" add constraint "accounts_item_id_fkey" FOREIGN KEY (item_id) REFERENCES plaid_items(id) not valid;

alter table "public"."accounts" validate constraint "accounts_item_id_fkey";

alter table "public"."accounts" add constraint "accounts_user_id_fkey" FOREIGN KEY (user_id) REFERENCES profiles(id) not valid;

alter table "public"."accounts" validate constraint "accounts_user_id_fkey";

alter table "public"."assets" add constraint "assets_user_id_fkey" FOREIGN KEY (user_id) REFERENCES profiles(id) not valid;

alter table "public"."assets" validate constraint "assets_user_id_fkey";

alter table "public"."goals" add constraint "goals_user_id_fkey" FOREIGN KEY (user_id) REFERENCES profiles(id) not valid;

alter table "public"."goals" validate constraint "goals_user_id_fkey";

alter table "public"."plaid_api_events" add constraint "plaid_api_events_item_id_fkey" FOREIGN KEY (item_id) REFERENCES plaid_items(id) not valid;

alter table "public"."plaid_api_events" validate constraint "plaid_api_events_item_id_fkey";

alter table "public"."plaid_api_events" add constraint "plaid_api_events_user_id_fkey" FOREIGN KEY (user_id) REFERENCES profiles(id) not valid;

alter table "public"."plaid_api_events" validate constraint "plaid_api_events_user_id_fkey";

alter table "public"."plaid_items" add constraint "plaid_items_user_id_fkey" FOREIGN KEY (user_id) REFERENCES profiles(id) not valid;

alter table "public"."plaid_items" validate constraint "plaid_items_user_id_fkey";

alter table "public"."plaid_link_events" add constraint "plaid_link_events_user_id_fkey" FOREIGN KEY (user_id) REFERENCES profiles(id) not valid;

alter table "public"."plaid_link_events" validate constraint "plaid_link_events_user_id_fkey";

alter table "public"."transactions" add constraint "transactions_account_id_fkey" FOREIGN KEY (account_id) REFERENCES accounts(id) not valid;

alter table "public"."transactions" validate constraint "transactions_account_id_fkey";

-- inserts a row into public.profiles
CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path = ''
AS $function$
begin
  insert into public."profiles" (id)
  values (new.id);
  return new;
end;
$function$
;

set check_function_bodies = off;

-- trigger the function every time a user is created
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

grant delete on table "public"."accounts" to "anon";

grant insert on table "public"."accounts" to "anon";

grant references on table "public"."accounts" to "anon";

grant select on table "public"."accounts" to "anon";

grant trigger on table "public"."accounts" to "anon";

grant truncate on table "public"."accounts" to "anon";

grant update on table "public"."accounts" to "anon";

grant delete on table "public"."accounts" to "authenticated";

grant insert on table "public"."accounts" to "authenticated";

grant references on table "public"."accounts" to "authenticated";

grant select on table "public"."accounts" to "authenticated";

grant trigger on table "public"."accounts" to "authenticated";

grant truncate on table "public"."accounts" to "authenticated";

grant update on table "public"."accounts" to "authenticated";

grant delete on table "public"."accounts" to "service_role";

grant insert on table "public"."accounts" to "service_role";

grant references on table "public"."accounts" to "service_role";

grant select on table "public"."accounts" to "service_role";

grant trigger on table "public"."accounts" to "service_role";

grant truncate on table "public"."accounts" to "service_role";

grant update on table "public"."accounts" to "service_role";

grant delete on table "public"."assets" to "anon";

grant insert on table "public"."assets" to "anon";

grant references on table "public"."assets" to "anon";

grant select on table "public"."assets" to "anon";

grant trigger on table "public"."assets" to "anon";

grant truncate on table "public"."assets" to "anon";

grant update on table "public"."assets" to "anon";

grant delete on table "public"."assets" to "authenticated";

grant insert on table "public"."assets" to "authenticated";

grant references on table "public"."assets" to "authenticated";

grant select on table "public"."assets" to "authenticated";

grant trigger on table "public"."assets" to "authenticated";

grant truncate on table "public"."assets" to "authenticated";

grant update on table "public"."assets" to "authenticated";

grant delete on table "public"."assets" to "service_role";

grant insert on table "public"."assets" to "service_role";

grant references on table "public"."assets" to "service_role";

grant select on table "public"."assets" to "service_role";

grant trigger on table "public"."assets" to "service_role";

grant truncate on table "public"."assets" to "service_role";

grant update on table "public"."assets" to "service_role";

grant delete on table "public"."goals" to "anon";

grant insert on table "public"."goals" to "anon";

grant references on table "public"."goals" to "anon";

grant select on table "public"."goals" to "anon";

grant trigger on table "public"."goals" to "anon";

grant truncate on table "public"."goals" to "anon";

grant update on table "public"."goals" to "anon";

grant delete on table "public"."goals" to "authenticated";

grant insert on table "public"."goals" to "authenticated";

grant references on table "public"."goals" to "authenticated";

grant select on table "public"."goals" to "authenticated";

grant trigger on table "public"."goals" to "authenticated";

grant truncate on table "public"."goals" to "authenticated";

grant update on table "public"."goals" to "authenticated";

grant delete on table "public"."goals" to "service_role";

grant insert on table "public"."goals" to "service_role";

grant references on table "public"."goals" to "service_role";

grant select on table "public"."goals" to "service_role";

grant trigger on table "public"."goals" to "service_role";

grant truncate on table "public"."goals" to "service_role";

grant update on table "public"."goals" to "service_role";

grant delete on table "public"."jobs" to "anon";

grant insert on table "public"."jobs" to "anon";

grant references on table "public"."jobs" to "anon";

grant select on table "public"."jobs" to "anon";

grant trigger on table "public"."jobs" to "anon";

grant truncate on table "public"."jobs" to "anon";

grant update on table "public"."jobs" to "anon";

grant delete on table "public"."jobs" to "authenticated";

grant insert on table "public"."jobs" to "authenticated";

grant references on table "public"."jobs" to "authenticated";

grant select on table "public"."jobs" to "authenticated";

grant trigger on table "public"."jobs" to "authenticated";

grant truncate on table "public"."jobs" to "authenticated";

grant update on table "public"."jobs" to "authenticated";

grant delete on table "public"."jobs" to "service_role";

grant insert on table "public"."jobs" to "service_role";

grant references on table "public"."jobs" to "service_role";

grant select on table "public"."jobs" to "service_role";

grant trigger on table "public"."jobs" to "service_role";

grant truncate on table "public"."jobs" to "service_role";

grant update on table "public"."jobs" to "service_role";

grant delete on table "public"."plaid_api_events" to "anon";

grant insert on table "public"."plaid_api_events" to "anon";

grant references on table "public"."plaid_api_events" to "anon";

grant select on table "public"."plaid_api_events" to "anon";

grant trigger on table "public"."plaid_api_events" to "anon";

grant truncate on table "public"."plaid_api_events" to "anon";

grant update on table "public"."plaid_api_events" to "anon";

grant delete on table "public"."plaid_api_events" to "authenticated";

grant insert on table "public"."plaid_api_events" to "authenticated";

grant references on table "public"."plaid_api_events" to "authenticated";

grant select on table "public"."plaid_api_events" to "authenticated";

grant trigger on table "public"."plaid_api_events" to "authenticated";

grant truncate on table "public"."plaid_api_events" to "authenticated";

grant update on table "public"."plaid_api_events" to "authenticated";

grant delete on table "public"."plaid_api_events" to "service_role";

grant insert on table "public"."plaid_api_events" to "service_role";

grant references on table "public"."plaid_api_events" to "service_role";

grant select on table "public"."plaid_api_events" to "service_role";

grant trigger on table "public"."plaid_api_events" to "service_role";

grant truncate on table "public"."plaid_api_events" to "service_role";

grant update on table "public"."plaid_api_events" to "service_role";

grant delete on table "public"."plaid_items" to "anon";

grant insert on table "public"."plaid_items" to "anon";

grant references on table "public"."plaid_items" to "anon";

grant select on table "public"."plaid_items" to "anon";

grant trigger on table "public"."plaid_items" to "anon";

grant truncate on table "public"."plaid_items" to "anon";

grant update on table "public"."plaid_items" to "anon";

grant delete on table "public"."plaid_items" to "authenticated";

grant insert on table "public"."plaid_items" to "authenticated";

grant references on table "public"."plaid_items" to "authenticated";

grant select on table "public"."plaid_items" to "authenticated";

grant trigger on table "public"."plaid_items" to "authenticated";

grant truncate on table "public"."plaid_items" to "authenticated";

grant update on table "public"."plaid_items" to "authenticated";

grant delete on table "public"."plaid_items" to "service_role";

grant insert on table "public"."plaid_items" to "service_role";

grant references on table "public"."plaid_items" to "service_role";

grant select on table "public"."plaid_items" to "service_role";

grant trigger on table "public"."plaid_items" to "service_role";

grant truncate on table "public"."plaid_items" to "service_role";

grant update on table "public"."plaid_items" to "service_role";

grant delete on table "public"."plaid_link_events" to "anon";

grant insert on table "public"."plaid_link_events" to "anon";

grant references on table "public"."plaid_link_events" to "anon";

grant select on table "public"."plaid_link_events" to "anon";

grant trigger on table "public"."plaid_link_events" to "anon";

grant truncate on table "public"."plaid_link_events" to "anon";

grant update on table "public"."plaid_link_events" to "anon";

grant delete on table "public"."plaid_link_events" to "authenticated";

grant insert on table "public"."plaid_link_events" to "authenticated";

grant references on table "public"."plaid_link_events" to "authenticated";

grant select on table "public"."plaid_link_events" to "authenticated";

grant trigger on table "public"."plaid_link_events" to "authenticated";

grant truncate on table "public"."plaid_link_events" to "authenticated";

grant update on table "public"."plaid_link_events" to "authenticated";

grant delete on table "public"."plaid_link_events" to "service_role";

grant insert on table "public"."plaid_link_events" to "service_role";

grant references on table "public"."plaid_link_events" to "service_role";

grant select on table "public"."plaid_link_events" to "service_role";

grant trigger on table "public"."plaid_link_events" to "service_role";

grant truncate on table "public"."plaid_link_events" to "service_role";

grant update on table "public"."plaid_link_events" to "service_role";

grant delete on table "public"."profiles" to "anon";

grant insert on table "public"."profiles" to "anon";

grant references on table "public"."profiles" to "anon";

grant select on table "public"."profiles" to "anon";

grant trigger on table "public"."profiles" to "anon";

grant truncate on table "public"."profiles" to "anon";

grant update on table "public"."profiles" to "anon";

grant delete on table "public"."profiles" to "authenticated";

grant insert on table "public"."profiles" to "authenticated";

grant references on table "public"."profiles" to "authenticated";

grant select on table "public"."profiles" to "authenticated";

grant trigger on table "public"."profiles" to "authenticated";

grant truncate on table "public"."profiles" to "authenticated";

grant update on table "public"."profiles" to "authenticated";

grant delete on table "public"."profiles" to "service_role";

grant insert on table "public"."profiles" to "service_role";

grant references on table "public"."profiles" to "service_role";

grant select on table "public"."profiles" to "service_role";

grant trigger on table "public"."profiles" to "service_role";

grant truncate on table "public"."profiles" to "service_role";

grant update on table "public"."profiles" to "service_role";

grant delete on table "public"."transactions" to "anon";

grant insert on table "public"."transactions" to "anon";

grant references on table "public"."transactions" to "anon";

grant select on table "public"."transactions" to "anon";

grant trigger on table "public"."transactions" to "anon";

grant truncate on table "public"."transactions" to "anon";

grant update on table "public"."transactions" to "anon";

grant delete on table "public"."transactions" to "authenticated";

grant insert on table "public"."transactions" to "authenticated";

grant references on table "public"."transactions" to "authenticated";

grant select on table "public"."transactions" to "authenticated";

grant trigger on table "public"."transactions" to "authenticated";

grant truncate on table "public"."transactions" to "authenticated";

grant update on table "public"."transactions" to "authenticated";

grant delete on table "public"."transactions" to "service_role";

grant insert on table "public"."transactions" to "service_role";

grant references on table "public"."transactions" to "service_role";

grant select on table "public"."transactions" to "service_role";

grant trigger on table "public"."transactions" to "service_role";

grant truncate on table "public"."transactions" to "service_role";

grant update on table "public"."transactions" to "service_role";
