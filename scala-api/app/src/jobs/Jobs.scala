package app.jobs

import app.common.LavinMqClient
import java.util.UUID
import scala.util.Try
import upickle.default._
import com.rabbitmq.client.{DeliverCallback}
import app.common.Logger
import com.rabbitmq.client.Delivery

object Jobs:
    val jobConnection = LavinMqClient.createConnection()
    val jobChannel = LavinMqClient.createChannel(jobConnection)
    val jobQueueName = "jobs"

    def init() =
        declareJobQueue()
        jobChannel.basicQos(1)
        enqueueJob(JobRequest.JobSyncPlaidItem(UUID.randomUUID(), itemId = UUID.randomUUID()))
        enqueueJob(JobRequest.AnotherJob(UUID.randomUUID(), data = "example data"))
        consumeJobs()

    private def declareJobQueue() =
        Try(jobChannel.queueDeclare(jobQueueName, true, false, false, null))

    def enqueueJob(job: JobRequest): Unit =
        declareJobQueue()
            .map(_ => jobChannel.basicPublish("", jobQueueName, null, write(job).getBytes()))

    enum JobRequest:
        case JobSyncPlaidItem(id: UUID = UUID.randomUUID(), itemId: UUID)
        case AnotherJob(id: UUID = UUID.randomUUID(), data: String)

    object JobRequest:
        implicit val jobSyncPlaidItemRW: ReadWriter[JobSyncPlaidItem] = macroRW
        implicit val anotherJobRW: ReadWriter[AnotherJob] = macroRW
        implicit val jobRequestRW: ReadWriter[JobRequest] = macroRW

    def consumeJobs() =
        val deliverCallback: DeliverCallback = (consumerTag, delivery) =>
            val body = new String(delivery.getBody, "UTF-8")
            val job = read[JobRequest](body)
            job match
                case job @ JobRequest.AnotherJob(id, input)       => handleAnotherJob(job, delivery)
                case job @ JobRequest.JobSyncPlaidItem(id, input) => handleJobSyncPlaidItem(job, delivery)

        jobChannel.basicConsume(
            jobQueueName,
            false, // Manual acknowledgment mode
            deliverCallback,
            consumerTag => ()
        )

    private def handleJobSyncPlaidItem(job: JobRequest.JobSyncPlaidItem, delivery: Delivery): Unit = {
        Logger.root.info(s"Handling JobSyncPlaidItem: $job")
        // Add your job handling logic here

        jobChannel.basicAck(delivery.getEnvelope.getDeliveryTag, false)
    }

    private def handleAnotherJob(job: JobRequest.AnotherJob, delivery: Delivery): Unit = {
        Logger.root.info(s"Handling AnotherJob: $job")
        // Add your job handling logic here
        jobChannel.basicAck(delivery.getEnvelope.getDeliveryTag, false)
    }
