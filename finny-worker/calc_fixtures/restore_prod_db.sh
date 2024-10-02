sh -c "export PGPASSWORD=postgres && pg_restore -h localhost -d postgres -U postgres -p 5432 -v calc_fixtures/supabase_prod_db.dump"
