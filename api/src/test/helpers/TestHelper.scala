package test.helpers

import api.database.Database
import api.common.*
import api.common.Environment
import api.jobs.*

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
