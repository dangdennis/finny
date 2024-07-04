package app

import app.database.Database
import app.utils.Environment
import app.utils.Environment.AppEnv
import app.utils.logger.Logger
import io.helidon.webserver.WebServer
import sttp.tapir.*
import sttp.tapir.server.nima.NimaServerInterpreter

@main def main: Unit =
  val appEnv = Environment.getAppEnv
  val port = Environment.getPort
  val jwtIssue = Environment.getJwtIssue
  val jwtSecret = Environment.getJwtSecret
  val databaseConfig = Environment.getDatabaseConfig

  appEnv match
    case AppEnv.Development =>
      Logger.root.info(s"Running in development mode.")
    case AppEnv.Production =>
      Logger.root.info(s"Running in production mode.")

  Logger.configureLogging()
  Database.init(configs = databaseConfig)

  val handler = NimaServerInterpreter().toHandler(Routes.createRoutes(Routes.AuthConfig(jwtSecret, jwtIssue)))

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

  Logger.root.info(s"Server started at: http://0.0.0.0:${server.port()}")
