package test.helpers

import app.database.Database
import app.utils.logger.LogConfig
import app.utils.Environment

object TestHelper:
  def beforeAll(): Unit =
    Database.init(configs = Environment.getDatabaseConfig)
    LogConfig.configureLogging()

  def beforeEach(): Unit =
    DatabaseHelper.truncateTables()
