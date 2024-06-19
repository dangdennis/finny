package test.helpers

import app.database.Database
import app.utils.logger.LogConfig

object TestHelper:
  def beforeAll(): Unit =
    Database.initForTests()
    LogConfig.configureLogging()

  def beforeEach(): Unit =
    DatabaseHelper.truncateTables()
