package app

import app.database.Database
import io.helidon.webserver.WebServer
import sttp.tapir._
import sttp.tapir.server.nima.NimaServerInterpreter

@main def main: Unit =
  Database.init()

  val handler = NimaServerInterpreter().toHandler(Endpoints.all)

  var appEnv = sys.env.getOrElse("APP_ENV", "development")
  val port = sys.env.get("HTTP_PORT").flatMap(_.toIntOption).getOrElse(8080)
  appEnv match
    case "development" =>
      println(s"Running in development mode.")
    case "production" =>
      println(s"Running in production mode.")
    case _ =>
      println(s"Running in unknown mode.")

  val server = WebServer
    .builder()
    .routing { builder =>
      builder.any(handler)
      ()
    }
    .host("0.0.0.0")
    .port(port)
    .build()
    .start()

  println(s"Server started at: http://0.0.0.0:${server.port()}")
