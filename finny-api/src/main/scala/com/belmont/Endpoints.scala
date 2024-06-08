package com.belmont

import sttp.tapir.*

import Library.*
import sttp.tapir.generic.auto.*
import sttp.tapir.json.upickle.*
import sttp.tapir.server.ServerEndpoint
import sttp.tapir.server.metrics.prometheus.PrometheusMetrics
import sttp.tapir.server.netty.sync.Id
import sttp.tapir.swagger.bundle.SwaggerInterpreter
import upickle.default.*

object Endpoints:
  case class User(name: String) extends AnyVal
  val helloEndpoint: PublicEndpoint[User, Unit, String, Any] = endpoint.get
    .in("hello")
    .in(query[User]("name"))
    .out(stringBody)
  val helloServerEndpoint: ServerEndpoint[Any, Id] = helloEndpoint.serverLogicSuccess(user => s"Hello ${user.name}")

  val booksListing: PublicEndpoint[Unit, Unit, List[Book], Any] = endpoint.get
    .in("books" / "list" / "all")
    .out(jsonBody[List[Book]])
  val booksListingServerEndpoint: ServerEndpoint[Any, Id] = booksListing.serverLogicSuccess(_ => (Library.books))

  val apiEndpoints: List[ServerEndpoint[Any, Id]] = List(helloServerEndpoint, booksListingServerEndpoint)

  val docEndpoints: List[ServerEndpoint[Any, Id]] = SwaggerInterpreter()
    .fromServerEndpoints[Id](apiEndpoints, "finny-api", "1.0.0")

  val prometheusMetrics: PrometheusMetrics[Id] = PrometheusMetrics.default[Id]()
  val metricsEndpoint: ServerEndpoint[Any, Id] = prometheusMetrics.metricsEndpoint

  val all: List[ServerEndpoint[Any, Id]] = apiEndpoints ++ docEndpoints ++ List(metricsEndpoint)

object Library:
  case class Author(name: String)
  case class Book(title: String, year: Int, author: Author)

  object Author:
    implicit val rw: ReadWriter[Author] = macroRW

  object Book:
    implicit val rw: ReadWriter[Book] = macroRW

  val books = List(
    Book("The Sorrows of Young Werther", 1774, Author("Johann Wolfgang von Goethe")),
    Book("On the Niemen", 1888, Author("Eliza Orzeszkowa")),
    Book("The Art of Computer Programming", 1968, Author("Donald Knuth")),
    Book("Pharaoh", 1897, Author("Boleslaw Prus"))
  )
