package api.database

import api.common.Environment
import api.common.Environment.DatabaseConfig
import scalasql.*
import scalasql.PostgresDialect.*
import scalikejdbc.*

import scala.util.Try

object DatabaseJdbc:
  def init(configs: DatabaseConfig) =
    Try:
      ConnectionPool.singleton(configs.host, configs.user, configs.password)

      // Ensure global settings are configured
      GlobalSettings.loggingSQLAndTime =
        LoggingSQLAndTimeSettings(enabled = true, singleLineMode = true)
    .toEither

object DatabaseScalaSql:
  def init(configs: DatabaseConfig) =
    Try:
      val hikariDataSource = new com.zaxxer.hikari.HikariDataSource()
      hikariDataSource.setJdbcUrl(configs.host)
      hikariDataSource.setUsername(configs.user)
      hikariDataSource.setPassword(configs.password)

      val hikariClient = new scalasql.DbClient.DataSource(
        hikariDataSource,
        config = new scalasql.Config {}
      )

      hikariClient
    .toEither
