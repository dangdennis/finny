package test.helpers

import scalikejdbc.DB
import scalikejdbc.SQL

object DatabaseHelper:
  def truncateTables(): Unit =
    val sql = """
      DO $$ DECLARE
          r RECORD;
      BEGIN
          FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public')
          LOOP
              EXECUTE 'TRUNCATE TABLE public.' || quote_ident(r.tablename) || ' CASCADE';
          END LOOP;
      END $$;

      TRUNCATE TABLE auth.users CASCADE;
    """

    DB.autoCommit { implicit session =>
      SQL(sql = sql).execute.apply()
    }
