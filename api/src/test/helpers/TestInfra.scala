package test.helpers

import api.common.*
import api.common.Environment
import api.database.DatabaseJdbc
import api.jobs.*
import org.scalatest.BeforeAndAfterAll
import org.scalatest.BeforeAndAfterEach
import org.scalatest.EitherValues
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers

trait TestInfra
    extends AnyFlatSpec,
      Matchers,
      EitherValues,
      BeforeAndAfterAll,
      BeforeAndAfterEach:
  override protected def beforeAll(): Unit =
    super.beforeAll()
    DatabaseJdbc.init(configs = Environment.getDatabaseConfig)
    Jobs.init()
    Logger.configureLogging()

  override protected def beforeEach(): Unit =
    super.beforeEach()
    DatabaseHelper.truncateTables()
    Jobs.jobChannel.queuePurge(Jobs.jobQueueName)

  override protected def afterEach(): Unit =
    super.afterEach()
    DatabaseHelper.truncateTables()
    Jobs.jobChannel.queuePurge(Jobs.jobQueueName)
