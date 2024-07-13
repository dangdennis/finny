package test.helpers

import app.database.Database
import app.common.*
import app.common.Environment

object TestHelper:
  def beforeAll(): Unit =
    Database.init(configs = Environment.getDatabaseConfig)
    Logger.configureLogging()

  def afterEach(): Unit =
    DatabaseHelper.truncateTables()
