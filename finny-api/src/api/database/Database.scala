package api.database

import api.common.Environment
import api.common.Environment.DatabaseConfig
import scalikejdbc.*

import scala.util.Try

object Database:
  def init(configs: DatabaseConfig) =
    Try:
      ConnectionPool.singleton(configs.host, configs.user, configs.password)

      // Ensure global settings are configured
      GlobalSettings.loggingSQLAndTime =
        LoggingSQLAndTimeSettings(enabled = true, singleLineMode = true)
    .toEither
