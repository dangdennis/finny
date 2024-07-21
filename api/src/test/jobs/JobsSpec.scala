package test.jobs

import api.common.LavinMqClient
import api.jobs.*
import api.jobs.Jobs.*
import io.circe.parser.decode
import org.scalatest.BeforeAndAfterAll
import org.scalatest.BeforeAndAfterEach
import org.scalatest.EitherValues
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import test.helpers.*

class JobsSpec extends AnyFlatSpec, Matchers, EitherValues, BeforeAndAfterAll, BeforeAndAfterEach:
    override protected def beforeAll(): Unit = TestHelper.beforeAll()
    override protected def beforeEach(): Unit = TestHelper.beforeEach()

    "enqueueJobs" should "send messages" in:
        // given
        val jobConnection = LavinMqClient.createConnection()
        val jobChannel = LavinMqClient.createChannel(jobConnection)
        val jobQueueName = "jobs"

        // when
        val jobMsg = JobRequest.AnotherJob(data = "someDataX")
        Jobs.enqueueJob(jobMsg)

        val itemId = java.util.UUID.randomUUID()
        val jobMsg2 = JobRequest.JobSyncPlaidItem(itemId = itemId, syncType = SyncType.Default, environment = "sandbox")
        Jobs.enqueueJob(jobMsg2)

        // then
        val response = jobChannel.basicGet(jobQueueName, false)
        val body = new String(response.getBody, "UTF-8")
        val anotherJob = decode[JobRequest.AnotherJob](body)
        anotherJob.value.data should be("someDataX")
        jobChannel.basicAck(response.getEnvelope.getDeliveryTag, false)

        val response2 = jobChannel.basicGet(jobQueueName, false)
        val body2 = new String(response2.getBody, "UTF-8")
        val jobSyncPlaidItem = decode[JobRequest.JobSyncPlaidItem](body2)
        jobSyncPlaidItem.value.itemId should be(itemId)
        jobSyncPlaidItem.value.syncType should be(SyncType.Default)
        jobSyncPlaidItem.value.syncType.toString should be("Default")
        jobChannel.basicAck(response2.getEnvelope.getDeliveryTag, false)
