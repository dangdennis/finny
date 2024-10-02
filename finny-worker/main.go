package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/joho/godotenv"
	"github.com/labstack/echo/v4"
	amqp "github.com/rabbitmq/amqp091-go"
)

func main() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Println("Error loading .env file:", err)
	} else {
		log.Println(".env file loaded successfully")
	}

	lavinMqUrl := os.Getenv("LAVIN_MQ_URL")
	if lavinMqUrl == "" {
		log.Fatal("LAVIN_MQ_URL is not set")
	}

	e := echo.New()

	conn, err := amqp.Dial(lavinMqUrl)
	if err != nil {
		log.Fatalf("Failed to connect to LavinMQ: %v", err)
	}
	defer conn.Close()

	ch, err := conn.Channel()
	if err != nil {
		log.Fatalf("Failed to open a channel: %v", err)
	}
	defer ch.Close()

	e.POST("/start", func(c echo.Context) error {
		return startWorker(c, conn, ch)
	})

	log.Println("Worker is ready to start on demand")
	e.Logger.Fatal(e.Start(":8080"))
}

func startWorker(c echo.Context, conn *amqp.Connection, ch *amqp.Channel) error {
	go processFinalyticsMessages(conn, ch)
	return c.String(http.StatusOK, "Worker started")
}

func processFinalyticsMessages(conn *amqp.Connection, ch *amqp.Channel) {
	// todo: inject service should create the queue and publish message
	// todo: inject service should also start the worker via POST /start
	queueName := "finalytics_queue"
	q, err := ch.QueueDeclare(
		queueName, // name
		true,      // durable
		false,     // delete when unused
		false,     // exclusive
		false,     // no-wait
		nil,       // arguments
	)
	if err != nil {
		log.Printf("Failed to declare a queue: %v", err)
		return
	}

	msgs, err := ch.Consume(
		q.Name, // queue
		"",     // consumer
		false,  // auto-ack
		false,  // exclusive
		false,  // no-local
		false,  // no-wait
		nil,    // args
	)
	if err != nil {
		log.Printf("Failed to register a consumer: %v", err)
		return
	}

	timeout := time.NewTimer(10 * time.Second)
	defer timeout.Stop()

	for {
		select {
		case msg, ok := <-msgs:
			if !ok {
				log.Println("Channel closed, stopping worker")
				return
			}

			fmt.Printf("Received a message: %s\n", msg.Body)
			processFinalyticMessage(&msg)

			msg.Ack(false)
			timeout.Reset(10 * time.Second)
		case <-timeout.C:
			log.Println("No messages received for 10 seconds, stopping worker")
			return
		}
	}
}

func processFinalyticMessage(msg *amqp.Delivery) {
	var finalyticMsg FinalyticMessage
	err := json.Unmarshal(msg.Body, &finalyticMsg)
	if err != nil {
		log.Printf("Error unmarshaling message: %v", err)
		return
	}

	fmt.Printf("Received a message: ID=%s, UserID=%s, Op=%s\n",
		finalyticMsg.Id, finalyticMsg.UserId, finalyticMsg.Op)
}

type FinalyticMessage struct {
	Id     string `json:"id"`
	UserId string `json:"user_id"`
	Op     string `json:"op"`
}
