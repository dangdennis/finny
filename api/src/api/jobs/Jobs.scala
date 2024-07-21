package api.jobs

import api.common.LavinMqClient
import api.common.Logger
import api.services.PlaidSyncService
import cats.syntax.all.*
import com.rabbitmq.client.Channel
import com.rabbitmq.client.Connection
import com.rabbitmq.client.DeliverCallback
import com.rabbitmq.client.Delivery
import io.circe.*
import io.circe.generic.semiauto.*
import io.circe.parser.*
import io.circe.syntax.*

import java.util.UUID
import scala.util.Try

object Jobs:
    val jobConnection: Connection = LavinMqClient.createConnection()
    val jobChannel: Channel = LavinMqClient.createChannel(jobConnection)
    val jobQueueName = "jobs"

    def init(): Either[Throwable, Unit] =
        Try:
            declareJobQueue()
            jobChannel.basicQos(1)
        .toEither

    private def declareJobQueue() = Try(jobChannel.queueDeclare(jobQueueName, true, false, false, null))

    def enqueueJob(job: JobRequest): Unit =
        val payload = job.asJson.noSpaces
        jobChannel.basicPublish("", jobQueueName, null, payload.getBytes("UTF-8"))

    enum SyncType:
        case Initial
        case Historical
        case Default

    object SyncType:
        given Encoder[SyncType] = Encoder
            .encodeString
            .contramap {
                case Initial =>
                    "Initial"
                case Historical =>
                    "Historical"
                case Default =>
                    "Default"
            }

        given Decoder[SyncType] = Decoder
            .decodeString
            .emap {
                case "Initial" =>
                    Right(Initial)
                case "Historical" =>
                    Right(Historical)
                case "Default" =>
                    Right(Default)
                case other =>
                    Left(s"Unknown SyncType: $other")
            }

    enum JobRequest:
        case JobSyncPlaidItem(id: UUID = UUID.randomUUID(), itemId: UUID, syncType: SyncType, environment: String)
        case AnotherJob(id: UUID = UUID.randomUUID(), data: String)

    object JobRequest:
        given Codec[JobSyncPlaidItem] = deriveCodec
        given Codec[AnotherJob] = deriveCodec
        given Encoder[JobRequest] = Encoder.instance {
            case job: JobSyncPlaidItem =>
                job.asJson
            case job: AnotherJob =>
                job.asJson
        }
        given Decoder[JobRequest] = Decoder[JobSyncPlaidItem].widen.or(Decoder[AnotherJob].widen)

    def startWorker(): Any =
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
