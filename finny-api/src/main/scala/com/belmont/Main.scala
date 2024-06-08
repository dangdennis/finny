package com.belmont

import ox.*
import sttp.tapir.server.netty.sync.{NettySyncServer, NettySyncServerOptions}

@main def run(): Unit = {
  def startServer(): Unit = {
    val serverOptions = NettySyncServerOptions.customiseInterceptors
      .metricsInterceptor(Endpoints.prometheusMetrics.metricsInterceptor())
      .options

    var appEnv = sys.env.getOrElse("APP_ENV", "development")
    val port = sys.env.get("HTTP_PORT").flatMap(_.toIntOption).getOrElse(8080)

    supervised {
      val binding = useInScope(NettySyncServer(serverOptions).port(port).addEndpoints(Endpoints.all).start())(_.stop())
      println(s"Go to http://localhost:${binding.port}/docs to open SwaggerUI.")

      appEnv match {
        case "development" =>
          println(s"Running in development mode.")
          println(s"Press ENTER to stop the server.")
          scala.io.StdIn.readLine()
        case "production" =>
          println(s"Running in production mode.")
        case _ =>
          println(s"Running in unknown mode.")
      }
    }
  }

  startServer()
}
