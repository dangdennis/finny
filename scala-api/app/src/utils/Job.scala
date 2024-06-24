package utils.job

import com.rabbitmq.client.*;
import app.utils.Environment
import scala.util.Try

object Job:
  private def JOB_QUEUE_NAME = "job_queue"

  def init(): Try[Connection] =
    for 
      conn <- makeConn
      _ <- makeQueue(conn)
    yield conn  
  
  private def makeConn: Try[Connection] =
    Try:
      val lavinMqUrl = Environment.getLavinMQUrl
      val factory = ConnectionFactory()
      factory.setUri(lavinMqUrl)
      factory.newConnection

  private def makeQueue(conn: Connection): Try[Unit] =
    Try:
      val channel = conn.createChannel()
      channel.queueDeclare(JOB_QUEUE_NAME, true, false, false, null)
    
  def publishJob(channel: Channel, job: String): Try[Unit] =
    Try:
      channel.basicPublish("", JOB_QUEUE_NAME, null, job.getBytes())

