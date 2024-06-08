package com.belmont

import sttp.tapir.*

import ox.*

import Library.*
import scala.concurrent.Future
import sttp.tapir.generic.auto.*
import sttp.tapir.json.upickle.*
import sttp.tapir.server.ServerEndpoint
import sttp.tapir.server.metrics.prometheus.PrometheusMetrics
import sttp.tapir.swagger.bundle.SwaggerInterpreter
import upickle.default.*

object Endpoints:
  case class User(name: String) extends AnyVal
  val helloEndpoint: PublicEndpoint[User, Unit, String, Any] = endpoint.get
    .in("hello2")
    .in(query[User]("name"))
    .out(stringBody)
  val helloServerEndpoint: ServerEndpoint[Any, sttp.shared.Identity] = helloEndpoint.serverLogicSuccess(user => s"Hello ${user.name}")

  val booksListing: PublicEndpoint[Unit, Unit, List[Book], Any] = endpoint.get
    .in("books" / "list" / "all")
    .out(jsonBody[List[Book]])
  val booksListingServerEndpoint: ServerEndpoint[Any, sttp.shared.Identity] = booksListing.serverLogicSuccess(_ => Library.books)

  val apiEndpoints: List[ServerEndpoint[Any, sttp.shared.Identity]] = List(helloServerEndpoint, booksListingServerEndpoint)

  val docEndpoints: List[ServerEndpoint[Any, sttp.shared.Identity]] = SwaggerInterpreter()
    .fromServerEndpoints[sttp.shared.Identity](apiEndpoints, "yammering-mouse", "1.0.0")

  val prometheusMetrics: PrometheusMetrics[sttp.shared.Identity] = PrometheusMetrics.default[sttp.shared.Identity]()
  val metricsEndpoint: ServerEndpoint[Any, sttp.shared.Identity] = prometheusMetrics.metricsEndpoint

  val all: List[ServerEndpoint[Any, sttp.shared.Identity]] = apiEndpoints ++ docEndpoints ++ List(metricsEndpoint)

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
