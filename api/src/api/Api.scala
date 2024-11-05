package api

import api.common.*
import api.database.DatabaseJdbc
import api.database.DatabaseScalaSql
import api.jobs.Jobs
import api.routes.Routes
import io.helidon.webserver.WebServer
import io.helidon.webserver.accesslog.AccessLogFeature
import scalasql.DbClient
import sttp.tapir.*
import sttp.tapir.server.nima.NimaServerInterpreter

import Environment.*

@main
def main: Unit =
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

  DatabaseJdbc
    .init(databaseConfig)
    .getOrElse(
      throw new IllegalStateException("Scalikejdbc Client not initialized")
    )

  Jobs.init().getOrElse(throw new IllegalStateException("Jobs not initialized"))

  given dbClient: DbClient.DataSource = DatabaseScalaSql
    .init(databaseConfig)
    .getOrElse(throw new IllegalStateException("DB Client not initialized"))

  val handler = NimaServerInterpreter().toHandler(
    Routes.createRoutes(Routes.AuthConfig(jwtSecret, jwtIssue))
  )

  val server = WebServer
    .builder()
    .addFeature(AccessLogFeature.builder().commonLogFormat().build())
    .routing { builder =>
      builder.any(handler)
      builder.get(
        "/oauth/plaid",
        (req, res) => res.send("Redirecting back to Finny")
      )
      ()
    }
    .host("0.0.0.0")
    .port(port)
    .build()
    .start()

  Jobs.startWorker()

  Logger.root.info(s"Server started at: http://0.0.0.0:${server.port()}")
