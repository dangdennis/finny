package app.common

import com.rabbitmq.client.Channel
import com.rabbitmq.client.Connection
import com.rabbitmq.client.ConnectionFactory

object LavinMqClient:
    private val factory = new ConnectionFactory()
    factory.setHost("localhost") // set your LavinMQ host
    factory.setPort(5672) // set your LavinMQ port
    factory.setUsername("guest") // set your LavinMQ username
    factory.setPassword("guest") // set your LavinMQ password
    factory.newConnection()

    def createConnection(): Connection =
        factory.newConnection()

    def createChannel(connection: Connection): Channel =
        connection.createChannel()