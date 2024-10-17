ALTER TABLE "public"."ynab_raw"
  ADD COLUMN "categories_last_knowledge_of_server" integer,
  ADD COLUMN "categories_last_updated" timestamp;
