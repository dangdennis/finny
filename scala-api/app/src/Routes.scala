package app

import app.dtos.*
import app.handlers.*
import app.models.*
import app.utils.logger.Logger
import com.auth0.jwt.*
import com.auth0.jwt.algorithms.Algorithm
import sttp.shared.Identity
import sttp.tapir.*
import sttp.tapir.json.upickle.*
import sttp.tapir.server.ServerEndpoint
import sttp.tapir.server.metrics.prometheus.PrometheusMetrics
import sttp.tapir.swagger.bundle.SwaggerInterpreter

import java.util.UUID
import scala.collection.JavaConverters.*
import scala.util.Try

object Routes:
  def makeAuthenticator(authConfig: AuthConfig): AuthenticationToken => Either[AuthenticationError, Profile] =
    val algorithm = Algorithm.HMAC256(authConfig.jwtSecret);
    (token: AuthenticationToken) =>
      val verifier = JWT.require(algorithm).withIssuer(authConfig.jwtIssuer).build();
      val decodedJwt = Try(verifier.verify(token.value))
      decodedJwt match
        case scala.util.Success(jwt) => Right(Profile(id = UUID.fromString(jwt.getSubject())))
        case scala.util.Failure(error) =>
          Logger.root.error(s"Error decoding JWT: ${error.getMessage()}")
          Left(AuthenticationError(404))

  def createRoutes(authConfig: AuthConfig) =
    val indexRoute = endpoint.get.in("").out(stringBody)
    val apiRoute = endpoint.in("api").tag("Finny API")

    val protectedApiRouteGroup = apiRoute
      .securityIn(auth.bearer[String]().mapTo[AuthenticationToken])
      .errorOut(plainBody[Int].mapTo[AuthenticationError])
      .handleSecurity(makeAuthenticator(authConfig))

    val indexEndpoint = indexRoute.handle(_ => IndexHandler.handleIndex())

    val plaidItemCreateRoute = protectedApiRouteGroup.post
      .in("plaid-items" / "create")
      .in(jsonBody[DTOs.PlaidItemCreateRequest])
      .out(jsonBody[DTOs.PlaidItemCreateResponse])

    val plaidItemCreateServerEndpoint = plaidItemCreateRoute
      .handle(user => input => PlaidItemHandler.handlePlaidItemCreate(user, input))

    val plaidItemSyncRoute = protectedApiRouteGroup.post
      .in("plaid-items" / "sync")
      .in(jsonBody[DTOs.PlaidItemSyncRequest])
    
    val plaidItemSyncServerEndpoint = plaidItemSyncRoute
      .handle(user => input => PlaidItemHandler.handlePlaidItemSync(user, input))

    val plaidLinkCreateEndpoint = protectedApiRouteGroup.post
      .in("plaid-links" / "create")
      .out(jsonBody[DTOs.PlaidLinkCreateResponse])
    val plaidLinkCreateServerEndpoint = plaidLinkCreateEndpoint.handle(profile => _ => PlaidLinkHandler.handler(userId = profile.id))

    val webhookEndpoint = endpoint.post
      .in("api" / "webhook" / "plaid")
      .in(stringJsonBody)
      .out(stringBody)
      .handle(rawJson => PlaidWebhookHandler.handleWebhook(rawJson))

    val secureServerEndpoints = List(plaidItemCreateServerEndpoint, plaidLinkCreateServerEndpoint)
    val serverEndpoints = List(indexEndpoint) ++ secureServerEndpoints
    val docEndpoints = SwaggerInterpreter()
      .fromServerEndpoints[Identity](serverEndpoints, "finny-api", "1.0.0")
    val metricsEndpoint: ServerEndpoint[Any, Identity] = PrometheusMetrics.default[Identity]().metricsEndpoint
    val all = serverEndpoints ++ docEndpoints ++ List(metricsEndpoint, webhookEndpoint)

    all

  case class AuthConfig(jwtSecret: String, jwtIssuer: String)
