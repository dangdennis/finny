create table "public"."oauth_states" (
  "id" uuid primary key default gen_random_uuid (),
  "state" text not null,
  "user_id" uuid not null,
  "created_at" timestamp(6)
  with
    time zone not null default CURRENT_TIMESTAMP,
    "expires_at" timestamp(6)
  with
    time zone not null,
    "updated_at" timestamp(6)
  with
    time zone not null default CURRENT_TIMESTAMP,
    "deleted_at" timestamp(6)
  with
    time zone
);

alter table "public"."oauth_states" enable row level security;

-- Create indexes
CREATE INDEX "ix:oauth_states.user_id" ON public.oauth_states USING btree (user_id);

CREATE UNIQUE INDEX "uq:oauth_states.state" ON public.oauth_states USING btree (state);

-- Add foreign key constraint
alter table "public"."oauth_states" add constraint "oauth_states_user_id_fkey" FOREIGN KEY (user_id) REFERENCES profiles (id) not valid;

alter table "public"."oauth_states" validate constraint "oauth_states_user_id_fkey";
