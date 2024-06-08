package sttp.tapir.examples

import ox.*
import sttp.tapir.*
import sttp.tapir.server.netty.sync.NettySyncServer
import com.belmont.Endpoints

@main def App(): Unit =
  NettySyncServer().addEndpoints(Endpoints.all).startAndWait()

  // supervised {
  // val serverBinding = useInScope(NettySyncServer().addEndpoint(helloWorld).start())(_.stop())
  // println(s"Tapir is running on http://${serverBinding.hostName}:${serverBinding.port}")
  // never
  // }
