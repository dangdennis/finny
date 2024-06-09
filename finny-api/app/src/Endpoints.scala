package app

import app.repositories.UserRepository
import com.plaid.client.ApiClient
import com.plaid.client.request.PlaidApi
import sttp.shared.Identity
import sttp.tapir._
import sttp.tapir.generic.auto._
import sttp.tapir.json.upickle._
import sttp.tapir.server.ServerEndpoint
import sttp.tapir.server.metrics.prometheus.PrometheusMetrics
import sttp.tapir.swagger.bundle.SwaggerInterpreter
import upickle.default._

import scala.collection.JavaConverters._

import Library._

def makePlaidClient() =
  val apiClient = new ApiClient(
    Map(
      "clientId" -> "661ac9375307a3001ba2ea46",
      "secret" -> "57ebac97c0bcf92f35878135d68793",
      "plaidVersion" -> "2020-09-14"
    ).asJava
  )

  apiClient.setPlaidAdapter(ApiClient.Sandbox)

  apiClient.createService(classOf[PlaidApi])

object Endpoints:
  case class User(name: String) extends AnyVal
  var indexEndpoint: PublicEndpoint[Unit, Unit, String, Any] = endpoint.get
    .in("")
    .out(stringBody)

  var indexServerEndpoint: ServerEndpoint[Any, Identity] = indexEndpoint.serverLogic(_ =>
    val () = UserRepository.getUsers()

    Right("Hello, world!")
  )

  val helloEndpoint: PublicEndpoint[User, Unit, String, Any] = endpoint.get
    .in("hello")
    .in(query[User]("name"))
    .out(stringBody)
  val helloServerEndpoint: ServerEndpoint[Any, Identity] = helloEndpoint.serverLogicSuccess(user => s"Hello ${user.name}")

  val booksListing: PublicEndpoint[Unit, Unit, List[Book], Any] = endpoint.get
    .in("books" / "list" / "all")
    .out(jsonBody[List[Book]])
  val booksListingServerEndpoint: ServerEndpoint[Any, Identity] = booksListing.serverLogicSuccess(_ => (Library.books))

  val apiEndpoints: List[ServerEndpoint[Any, Identity]] = List(helloServerEndpoint, booksListingServerEndpoint, indexServerEndpoint)

  val docEndpoints: List[ServerEndpoint[Any, Identity]] = SwaggerInterpreter()
    .fromServerEndpoints[Identity](apiEndpoints, "finny-api", "1.0.0")

  val prometheusMetrics: PrometheusMetrics[Identity] = PrometheusMetrics.default[Identity]()
  val metricsEndpoint: ServerEndpoint[Any, Identity] = prometheusMetrics.metricsEndpoint

  val all: List[ServerEndpoint[Any, Identity]] = apiEndpoints ++ docEndpoints ++ List(metricsEndpoint)

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
