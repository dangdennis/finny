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

    supervised {
      val binding = useInScope(NettySyncServer(serverOptions).host("0.0.0.0").port(port).addEndpoints(Endpoints.all).start())(_.stop())
      println(s"Go to http://0.0.0.0:${binding.port}/docs to open SwaggerUI.")

      appEnv match
        case "development" =>
          println(s"Running in development mode.")
          println(s"Press Enter to stop the server.")
          scala.io.StdIn.readLine()
        case "production" =>
          println(s"Running in production mode.")
          never
        case _ =>
          println(s"Running in unknown mode.")
      
    }
  }

}
