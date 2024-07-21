package test.helpers

import app.database.Database
import app.common.*
import app.common.Environment
import app.jobs.*

object TestHelper:
    def beforeAll(): Unit =
        Database.init(configs = Environment.getDatabaseConfig)
        Jobs.init()
        Logger.configureLogging()

    def beforeEach(): Unit =
        DatabaseHelper.truncateTables()
        Jobs.jobChannel.queuePurge(Jobs.jobQueueName)

    def afterEach(): Unit =
        DatabaseHelper.truncateTables()
        Jobs.jobChannel.queuePurge(Jobs.jobQueueName)
