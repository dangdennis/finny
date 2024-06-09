package app

import app.dtos._
import app.handlers._
import com.plaid.client.ApiClient
import com.plaid.client.request.PlaidApi
import sttp.shared.Identity
import sttp.tapir._
import sttp.tapir.json.upickle._
import sttp.tapir.server.ServerEndpoint
import sttp.tapir.server.metrics.prometheus.PrometheusMetrics
import sttp.tapir.swagger.bundle.SwaggerInterpreter

import scala.collection.JavaConverters._

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
  val indexEndpoint = endpoint.get
    .in("")
    .out(stringBody)

  val indexServerEndpoint = indexEndpoint.handle(_ => IndexHandler.handleIndex())

  val plaidItemLinkEndpoint = endpoint.post
    .in("plaid-item" / "create")
    .in(jsonBody[DTOs.PlaidItemCreateRequest])
    .out(jsonBody[DTOs.PlaidItemCreateResponse])

  val plaidItemCreateServerEndpoint = plaidItemLinkEndpoint.handle(_ => PlaidItemHandler.handlePlaidItemCreate())

  val plaidLinkCreateEndpoint = endpoint.post
    .in("plaid-link" / "create")
    .in(jsonBody[DTOs.PlaidLinkCreateRequest])
    .out(jsonBody[DTOs.PlaidLinkCreateResponse])

  val plaidLinkCreateServerEndpoint = plaidLinkCreateEndpoint.handle(_ => PlaidLinkHandler.handler())

  val apiEndpoints: List[ServerEndpoint[Any, Identity]] =
    List(indexServerEndpoint, plaidItemCreateServerEndpoint, plaidLinkCreateServerEndpoint)
  val docEndpoints: List[ServerEndpoint[Any, Identity]] = SwaggerInterpreter()
    .fromServerEndpoints[Identity](apiEndpoints, "finny-api", "1.0.0")
  val prometheusMetrics: PrometheusMetrics[Identity] = PrometheusMetrics.default[Identity]()
  val metricsEndpoint: ServerEndpoint[Any, Identity] = prometheusMetrics.metricsEndpoint

  val all: List[ServerEndpoint[Any, Identity]] = apiEndpoints ++ docEndpoints ++ List(metricsEndpoint)
