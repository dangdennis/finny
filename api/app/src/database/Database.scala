package app.database

import app.common.Environment
import app.common.Environment.DatabaseConfig
import scalikejdbc.*

object Database:
    def init(configs: DatabaseConfig): Unit =
        ConnectionPool.singleton(
            configs.url,
            configs.user,
            configs.password
        )

        // Ensure global settings are configured
        GlobalSettings.loggingSQLAndTime = LoggingSQLAndTimeSettings(
            enabled = true,
            singleLineMode = true
        )