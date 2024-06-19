package test.helpers

import app.database.Database
import utils.logger.LogConfig

object TestHelper:
  def beforeAll(): Unit =
    Database.initForTests()
    LogConfig.configureLogging()
    DatabaseHelper.truncateTables()
