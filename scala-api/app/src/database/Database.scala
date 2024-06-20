package app.database

import app.utils.Environment
import app.utils.Environment.DatabaseConfig
import scalikejdbc.*

object Database:
  def init(configs: DatabaseConfig): Unit =
    ConnectionPool.singleton(
      configs.url,
      configs.user,
      configs.password,
    )