package test.services

import api.common.Environment.DatabaseConfig
import scalikejdbc.ConnectionPool

import scala.util.Try

object FinalyticsDatabase:
  def init(configs: DatabaseConfig) =
    Try:
      ConnectionPool.singleton(configs.host, configs.user, configs.password)
    .toEither
