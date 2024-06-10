package app

import app.dtos._
import app.handlers._
import app.models._
import sttp.shared.Identity
import sttp.tapir._
import sttp.tapir.json.upickle._
import sttp.tapir.server.ServerEndpoint
import sttp.tapir.server.metrics.prometheus.PrometheusMetrics
import sttp.tapir.swagger.bundle.SwaggerInterpreter

import scala.collection.JavaConverters._

object Endpoints:
  def authenticate(token: AuthenticationToken): Either[AuthenticationError, User] =
    // todo: decode JWT here and return user
    if (token.value == "berries") Right(User(id = "Papa Smurf"))
    else if (token.value == "smurf") Right(User(id = "Gargamel"))
    else Left(AuthenticationError(404))

  val base = endpoint.in("api").tag("Finny API")

  val secureEndpoint = base
    .securityIn(auth.bearer[String]().mapTo[AuthenticationToken])
    .errorOut(plainBody[Int].mapTo[AuthenticationError])
    .handleSecurity(authenticate)

  val indexEndpoint = base.get
    .in("")
    .out(stringBody)

  val indexServerEndpoint = indexEndpoint.handle(_ => IndexHandler.handleIndex())

  val plaidItemLinkEndpoint = secureEndpoint.post
    .in("plaid-items" / "create")
    .in(jsonBody[DTOs.PlaidItemCreateRequest])
    .out(jsonBody[DTOs.PlaidItemCreateResponse])

  val plaidItemCreateServerEndpoint = plaidItemLinkEndpoint
    .handle(user => _ => PlaidItemHandler.handlePlaidItemCreate(user))

  val plaidLinkCreateEndpoint = secureEndpoint.post
    .in("plaid-links" / "create")
    .in(jsonBody[DTOs.PlaidLinkCreateRequest])
    .out(jsonBody[DTOs.PlaidLinkCreateResponse])

  val plaidLinkCreateServerEndpoint = plaidLinkCreateEndpoint.handle(p1 => p2 => PlaidLinkHandler.handler())

  val secureServerEndpoints = List(plaidItemCreateServerEndpoint, plaidLinkCreateServerEndpoint)
  val serverEndpoints = List(indexServerEndpoint) ++ secureServerEndpoints
  val docEndpoints = SwaggerInterpreter()
    .fromServerEndpoints[Identity](serverEndpoints, "finny-api", "1.0.0")
  val metricsEndpoint: ServerEndpoint[Any, Identity] = PrometheusMetrics.default[Identity]().metricsEndpoint

  val all = serverEndpoints ++ docEndpoints ++ List(metricsEndpoint)
