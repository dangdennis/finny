package app

import app.database.Database
import io.helidon.webserver.WebServer
import sttp.tapir._
import sttp.tapir.server.nima.NimaServerInterpreter

object Main {
  def main(args: Array[String]): Unit = {
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

    WebServer
      .builder()
      .routing { builder =>
        builder.any(handler)
        ()
      }
      .port(port)
      .build()
      .start()
  }
}
