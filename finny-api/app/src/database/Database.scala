package app.database

import scalikejdbc._

object Database:
  def init(): Unit =
    ConnectionPool.singleton(
      "jdbc:postgresql://fly-0-ewr.pooler.supabase.com:6543/postgres",
      "postgres.ogagpskctstoizavqalo",
      "EzixzyhmYtIy5216"
    )
