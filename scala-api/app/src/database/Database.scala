package app.database

import scalikejdbc._

object Database:
  def init(): Unit =
    ConnectionPool.singleton(
      "jdbc:postgresql://aws-0-us-east-1.pooler.supabase.com:6543/postgres",
      "postgres.tqonkxhrucymdyndpjzf",
      "I07R6V4POCTi5wd4"
    )
