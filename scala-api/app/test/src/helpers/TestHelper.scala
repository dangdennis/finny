package test.helpers

import app.database.Database
import app.utils.logger.Logger
import app.utils.Environment

object TestHelper:
  def beforeAll(): Unit =
    Database.init(configs = Environment.getDatabaseConfig)
    Logger.configureLogging()

  def beforeEach(): Unit =
    DatabaseHelper.truncateTables()
