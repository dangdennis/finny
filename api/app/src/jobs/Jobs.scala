package app.jobs

import app.common.LavinMqClient
import app.common.Logger
import app.services.PlaidSyncService
import com.rabbitmq.client.DeliverCallback
import com.rabbitmq.client.Delivery
import upickle.default.*

import java.util.UUID
import scala.util.Try

object Jobs:
    val jobConnection = LavinMqClient.createConnection()
    val jobChannel = LavinMqClient.createChannel(jobConnection)
    val jobQueueName = "jobs"

    def init() =
        declareJobQueue()
        jobChannel.basicQos(1)

    private def declareJobQueue() =
        Try(jobChannel.queueDeclare(jobQueueName, true, false, false, null))

    def enqueueJob(job: JobRequest): Unit =
        declareJobQueue()
            .map(_ => jobChannel.basicPublish("", jobQueueName, null, write(job).getBytes()))

    enum SyncType:
        case Initial
        case Historical
        case Default

    object SyncType:
        implicit val initialRW: ReadWriter[SyncType.Initial.type] = macroRW
        implicit val historicalRW: ReadWriter[SyncType.Historical.type] = macroRW
        implicit val defaultRW: ReadWriter[SyncType.Default.type] = macroRW
        implicit val syncTypeRW: ReadWriter[SyncType] = macroRW

    enum JobRequest:
        case JobSyncPlaidItem(id: UUID = UUID.randomUUID(), itemId: UUID, syncType: SyncType, environment: String)
        case AnotherJob(id: UUID = UUID.randomUUID(), data: String)

    object JobRequest:
        implicit val jobSyncPlaidItemRW: ReadWriter[JobRequest.JobSyncPlaidItem] = macroRW
        implicit val anotherJobRW: ReadWriter[JobRequest.AnotherJob] = macroRW
        implicit val jobRequestRW: ReadWriter[JobRequest] = macroRW

    def startWorker() =
        val deliverCallback: DeliverCallback = (consumerTag, delivery) =>
            val body = new String(delivery.getBody, "UTF-8")
            Try(read[JobRequest](body)).toEither.left
                .map { e =>
                    Logger.root.error(s"Failed to parse job request: $body", e)
                }
                .map { job =>
                    job match
                        case job: JobRequest.AnotherJob       => handleAnotherJob(job, delivery)
                        case job: JobRequest.JobSyncPlaidItem => handleJobSyncPlaidItem(job, delivery)
                }

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
                PlaidSyncService.sync(
                    itemId = job.itemId
                )
            case SyncType.Historical =>
                PlaidSyncService.syncHistorical(
                    itemId = job.itemId
                )

        jobChannel.basicAck(delivery.getEnvelope.getDeliveryTag, false)

    private def handleAnotherJob(job: JobRequest.AnotherJob, delivery: Delivery): Unit =
        Logger.root.info(s"Handling AnotherJob: $job")
        // Add your job handling logic here
        jobChannel.basicAck(delivery.getEnvelope.getDeliveryTag, false)
