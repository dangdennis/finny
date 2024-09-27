package api.common

import com.rabbitmq.client.Channel
import com.rabbitmq.client.Connection
import com.rabbitmq.client.ConnectionFactory

import javax.net.ssl.SSLContext

object LavinMqClient:
  private val factory = new ConnectionFactory()
  private val lavinMqUrl = Environment.getLavinMqUrl

  // Ensure SSL context is set up properly for amqps
  if lavinMqUrl.getScheme == "amqps" then
    val sslContext = SSLContext.getInstance("TLS")
    sslContext.init(null, null, null) // use default key and trust managers
    factory.useSslProtocol(sslContext)

  factory.setUri(lavinMqUrl)
  factory.newConnection()

  def createConnection(): Connection =
    Logger.root.info(s"Connecting to LavinMQ")
    factory.newConnection()

  def createChannel(connection: Connection): Channel =
    Logger.root.info(s"Creating a new channel")
    connection.createChannel()
