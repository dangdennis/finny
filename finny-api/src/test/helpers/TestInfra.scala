package test.helpers

import api.common.*
import api.common.Environment
import api.database.Database
import api.jobs.*

trait TestInfra:
  private def beforeAll(): Unit =
    Database.init(configs = Environment.getDatabaseConfig)
    Jobs.init()
    Logger.configureLogging()

  private def beforeEach(): Unit =
    DatabaseHelper.truncateTables()
    Jobs.jobChannel.queuePurge(Jobs.jobQueueName)

  private def afterEach(): Unit =
    DatabaseHelper.truncateTables()
    Jobs.jobChannel.queuePurge(Jobs.jobQueueName)
