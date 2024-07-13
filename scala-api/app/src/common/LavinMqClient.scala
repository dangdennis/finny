package app.common

import com.rabbitmq.client.Channel
import com.rabbitmq.client.Connection
import com.rabbitmq.client.ConnectionFactory

object LavinMqClient:
    private val factory = new ConnectionFactory()
    private val lavinMqUrl = Environment.getLavinMqUrl
    factory.setHost(lavinMqUrl.getHost()) // set your LavinMQ host
    factory.setPort(lavinMqUrl.getPort()) // set your LavinMQ port

    val userInfo = lavinMqUrl.getUserInfo.split(":")
    if (userInfo.length == 2) {
        factory.setUsername(userInfo(0))
        factory.setPassword(userInfo(1))
    }

    factory.newConnection()

    def createConnection(): Connection =
        factory.newConnection()

    def createChannel(connection: Connection): Channel =
        connection.createChannel()
