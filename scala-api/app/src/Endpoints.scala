package app

import app.dtos.*
import app.handlers.*
import app.models.*
import com.auth0.jwt.*
import com.auth0.jwt.algorithms.Algorithm
import org.slf4j.LoggerFactory
import sttp.shared.Identity
import sttp.tapir.*
import sttp.tapir.json.upickle.*
import sttp.tapir.server.ServerEndpoint
import sttp.tapir.server.metrics.prometheus.PrometheusMetrics
import sttp.tapir.swagger.bundle.SwaggerInterpreter

import java.util.UUID
import scala.collection.JavaConverters.*
import scala.util.Try

object Endpoints:
  private val logger = LoggerFactory.getLogger(this.getClass)


  case class AuthConfig(jwtSecret: String, jwtIssuer: String)

  def makeAuthenticator(authConfig: AuthConfig): AuthenticationToken => Either[AuthenticationError, Profile] =
    val algorithm = Algorithm.HMAC256(authConfig.jwtSecret);
  
    (token: AuthenticationToken) =>
      val verifier = JWT.require(algorithm).withIssuer(authConfig.jwtIssuer).build();
      val decodedJwt = Try(verifier.verify(token.value))
      decodedJwt match
        case scala.util.Success(jwt) => Right(Profile(id = UUID.fromString(jwt.getSubject())))
        case scala.util.Failure(error) =>
          logger.error(s"Error decoding JWT: ${error.getMessage()}")
          Left(AuthenticationError(404))

  def createEndpoints(authConfig: AuthConfig) =
    val rootEndpoint = endpoint.get.in("").out(stringBody)
    val rootApiEndpoint = endpoint.in("api").tag("Finny API")
    val secureApiEndpoint = rootApiEndpoint
      .securityIn(auth.bearer[String]().mapTo[AuthenticationToken])
      .errorOut(plainBody[Int].mapTo[AuthenticationError])
      .handleSecurity(makeAuthenticator(authConfig))

    val indexServerEndpoint = rootEndpoint.handle(_ => IndexHandler.handleIndex())
    val plaidItemCreateEndpoint = secureApiEndpoint.post
      .in("plaid-items" / "create")
      .in(jsonBody[DTOs.PlaidItemCreateRequest])
      .out(jsonBody[DTOs.PlaidItemCreateResponse])
    val plaidItemCreateServerEndpoint = plaidItemCreateEndpoint
      .handle(user => input => PlaidItemHandler.handlePlaidItemCreate(user, input))
    val plaidLinkCreateEndpoint = secureApiEndpoint.post
      .in("plaid-links" / "create")
      .out(jsonBody[DTOs.PlaidLinkCreateResponse])
    val plaidLinkCreateServerEndpoint = plaidLinkCreateEndpoint.handle(p1 => p2 => PlaidLinkHandler.handler())

    val secureServerEndpoints = List(plaidItemCreateServerEndpoint, plaidLinkCreateServerEndpoint)
    val serverEndpoints = List(indexServerEndpoint) ++ secureServerEndpoints
    val docEndpoints = SwaggerInterpreter()
      .fromServerEndpoints[Identity](serverEndpoints, "finny-api", "1.0.0")
    val metricsEndpoint: ServerEndpoint[Any, Identity] = PrometheusMetrics.default[Identity]().metricsEndpoint
    val all = serverEndpoints ++ docEndpoints ++ List(metricsEndpoint)

    all
