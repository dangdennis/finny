package api

import api.routes.Routes
import api.common.*, Environment.*
import api.database.Database
import api.jobs.Jobs
import io.helidon.webserver.WebServer
import sttp.tapir.*
import sttp.tapir.server.nima.NimaServerInterpreter

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
    Database.init(databaseConfig)
    Jobs.init()

    val handler = NimaServerInterpreter().toHandler(Routes.createRoutes(Routes.AuthConfig(jwtSecret, jwtIssue)))

    val server = WebServer
        .builder()
        .routing { builder =>
            builder.any(handler)
            builder.get("/oauth/plaid", (req, res) => res.send("Redirecting back to Finny"))
            ()
        }
        .host("0.0.0.0")
        .port(port)
        .build()
        .start()

    Jobs.startWorker()

    Logger.root.info(s"Server started at: http://0.0.0.0:${server.port()}")
