package app.database

import app.utils.Environment
import scalikejdbc._

object Database:
  def init(): Unit =
    val databaseConfigs = Environment.getDatabaseConfig.getOrElse(sys.error("Database config not found"))
    ConnectionPool.singleton(
      databaseConfigs.url,
      databaseConfigs.user,
      databaseConfigs.password,
    )