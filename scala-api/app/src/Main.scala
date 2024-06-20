package app

import app.database.Database
import app.utils.Environment
import app.utils.Environment.AppEnv
import app.utils.logger.LogConfig
import io.helidon.webserver.WebServer
import sttp.tapir._
import sttp.tapir.server.nima.NimaServerInterpreter

@main def main: Unit =
  LogConfig.configureLogging()
  Database.init()

  val handler = NimaServerInterpreter().toHandler(Endpoints.createEndpoints())
  val appEnv = Environment.getAppEnv
  val port = Environment.getPort

  appEnv match
    case AppEnv.Development =>
      println(s"Running in development mode.")
    case AppEnv.Production =>
      println(s"Running in production mode.")

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
