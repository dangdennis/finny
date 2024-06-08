package com.belmont

import ox.*
import sttp.tapir.server.netty.sync.{NettySyncServer, NettySyncServerOptions}

@main def run(): Unit = {
  def startServer(): Unit = {
    val serverOptions = NettySyncServerOptions.customiseInterceptors
      .metricsInterceptor(Endpoints.prometheusMetrics.metricsInterceptor())
      .options

    val port = sys.env.get("HTTP_PORT").flatMap(_.toIntOption).getOrElse(8080)

    supervised {
      val binding = useInScope(NettySyncServer(serverOptions).port(port).addEndpoints(Endpoints.all).start())(_.stop())
      println(s"Go to http://localhost:${binding.port}/docs to open SwaggerUI.")
      println(s"Press ENTER to stop the server.")
      scala.io.StdIn.readLine()
    }
  }

  startServer()
}
