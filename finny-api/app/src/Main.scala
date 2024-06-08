package app

import ox.*
import sttp.tapir.server.netty.sync.{NettySyncServer, NettySyncServerOptions}

object Main {
  def main(args: Array[String]): Unit = {
    val serverOptions = NettySyncServerOptions.customiseInterceptors
      .metricsInterceptor(Endpoints.prometheusMetrics.metricsInterceptor())
      .options

    var appEnv = sys.env.getOrElse("APP_ENV", "development")
    val port = sys.env.get("HTTP_PORT").flatMap(_.toIntOption).getOrElse(8080)

    appEnv match {
      case "development" =>
        println(s"Running in development mode.")
      case "production" =>
        println(s"Running in production mode.")
      case _ =>
        println(s"Running in unknown mode.")
    }

    supervised {
      val binding = useInScope(NettySyncServer(serverOptions).host("0.0.0.0").port(port).addEndpoints(Endpoints.all).start())(_.stop())
      println(s"Go to http://localhost:${binding.port}/docs to open SwaggerUI.")
      never
    }
  }

}
