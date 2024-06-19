package app

import app.dtos._
import app.handlers._
import app.models._
import com.auth0.jwt._
import com.auth0.jwt.algorithms.Algorithm
import org.slf4j.LoggerFactory
import sttp.shared.Identity
import sttp.tapir._
import sttp.tapir.json.upickle._
import sttp.tapir.server.ServerEndpoint
import sttp.tapir.server.metrics.prometheus.PrometheusMetrics
import sttp.tapir.swagger.bundle.SwaggerInterpreter

import java.util.UUID
import scala.collection.JavaConverters._
import scala.util.Try

object Endpoints:
  private val logger = LoggerFactory.getLogger(this.getClass)

  def authenticate(token: AuthenticationToken): Either[AuthenticationError, Profile] =
    val jwtSecret = "09sUFObcLZHvtRvj5LBqtQomVPuVqOAa/LW2hcdQqyxCwpH9JDOGPwmn6XHMpaxqUPfRWkxTgiB9i4rb1Vwxwg=="
    val algorithm = Algorithm.HMAC256(jwtSecret);
    val verifier = JWT.require(algorithm).withIssuer("https://tqonkxhrucymdyndpjzf.supabase.co/auth/v1").build();
    val decodedJwt = Try(verifier.verify(token.value))
    decodedJwt match
      case scala.util.Success(jwt) => Right(Profile(id = UUID.fromString(jwt.getSubject())))
      case scala.util.Failure(error) =>
        logger.error(s"Error decoding JWT: ${error.getMessage()}")
        Left(AuthenticationError(404))

  def createEndpoints() =
    val rootEndpoint = endpoint.get.in("").out(stringBody)
    val rootApiEndpoint = endpoint.in("api").tag("Finny API")
    val secureApiEndpoint = rootApiEndpoint
      .securityIn(auth.bearer[String]().mapTo[AuthenticationToken])
      .errorOut(plainBody[Int].mapTo[AuthenticationError])
      .handleSecurity(authenticate)

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
