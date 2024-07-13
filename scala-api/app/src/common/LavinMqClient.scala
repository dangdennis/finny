package app.common

import com.rabbitmq.client.Channel
import com.rabbitmq.client.Connection
import com.rabbitmq.client.ConnectionFactory

object LavinMqClient:
    private val factory = new ConnectionFactory()
    private val lavinMqUrl = Environment.getLavinMqUrl
    factory.setUri(lavinMqUrl)
    factory.newConnection()

    def createConnection(): Connection =
        Logger.root.info(s"Connecting to LavinMQ")
        factory.newConnection()

    def createChannel(connection: Connection): Channel =
        Logger.root.info(s"Creating a new channel")
        connection.createChannel()
