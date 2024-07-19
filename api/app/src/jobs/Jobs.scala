package app.jobs

import app.common.LavinMqClient
import app.common.Logger
import app.services.PlaidSyncService
import com.rabbitmq.client.DeliverCallback
import com.rabbitmq.client.Delivery
import io.circe._
import io.circe.generic.auto._
import io.circe.syntax._
import io.circe.parser._

import java.util.UUID
import scala.util.Try

object Jobs:
    val jobConnection = LavinMqClient.createConnection()
    val jobChannel = LavinMqClient.createChannel(jobConnection)
    val jobQueueName = "jobs"

    def init() =
        Try:
            declareJobQueue()
            jobChannel.basicQos(1)
        .toEither

    private def declareJobQueue() = Try(jobChannel.queueDeclare(jobQueueName, true, false, false, null))

    def enqueueJob(job: JobRequest): Unit = declareJobQueue()
        .map(_ => jobChannel.basicPublish("", jobQueueName, null, job.asJson.noSpaces.getBytes()))

    enum SyncType:
        case Initial
        case Historical
        case Default

    enum JobRequest:
        case JobSyncPlaidItem(id: UUID = UUID.randomUUID(), itemId: UUID, syncType: SyncType, environment: String)
        case AnotherJob(id: UUID = UUID.randomUUID(), data: String)
        
    def startWorker() =
        val deliverCallback: DeliverCallback =
            (consumerTag, delivery) =>
                val body = new String(delivery.getBody, "UTF-8")
                decode[JobRequest](body) match
                    case Left(e) =>
                        Logger.root.error(s"Failed to parse job request: $body", e)
                    case Right(job) =>
                        job match
                            case job: JobRequest.AnotherJob =>
                                handleAnotherJob(job, delivery)
                            case job: JobRequest.JobSyncPlaidItem =>
                                handleJobSyncPlaidItem(job, delivery)

        jobChannel.basicConsume(
            jobQueueName,
            false, // Manual acknowledgment mode
            deliverCallback,
            consumerTag => ()
        )

    private def handleJobSyncPlaidItem(job: JobRequest.JobSyncPlaidItem, delivery: Delivery): Unit =
        Logger.root.info(s"Handling $job")

        job.syncType match
            case SyncType.Initial | SyncType.Default =>
                PlaidSyncService.sync(itemId = job.itemId)
            case SyncType.Historical =>
                PlaidSyncService.syncHistorical(itemId = job.itemId)

        jobChannel.basicAck(delivery.getEnvelope.getDeliveryTag, false)

    private def handleAnotherJob(job: JobRequest.AnotherJob, delivery: Delivery): Unit =
        Logger.root.info(s"Handling AnotherJob: $job")
        // Add your job handling logic here
        jobChannel.basicAck(delivery.getEnvelope.getDeliveryTag, false)
