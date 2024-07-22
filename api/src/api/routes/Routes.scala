package api.routes

import api.common.*
import api.dtos.*
import api.handlers.*
import api.models.*
import api.repositories.ProfileRepository
import com.auth0.jwt.*
import com.auth0.jwt.algorithms.Algorithm
import io.circe.generic.auto.*
import sttp.shared.Identity
import sttp.tapir.*
import sttp.tapir.json.circe.*
import sttp.tapir.server.ServerEndpoint
import sttp.tapir.server.metrics.prometheus.PrometheusMetrics
import sttp.tapir.swagger.bundle.SwaggerInterpreter

import java.util.UUID
import scala.util.Failure
import scala.util.Success
import scala.util.Try

object Routes:
    def createRoutes(authConfig: AuthConfig): List[ServerEndpoint[Any, Identity]] =
        val indexEndpoint = endpoint.in("").get.out(stringBody).handle(_ => IndexHandler.handleIndex())

        val protectedApiRouteGroup = endpoint
            .tag("Finny API")
            .securityIn(auth.bearer[String]().mapTo[AuthenticationToken])
            .errorOut(plainBody[Int].mapTo[AuthenticationError])
            .handleSecurity(makeAuthenticator(authConfig))

        val usersDeleteRoute = protectedApiRouteGroup.delete.in("users" / "delete")

        val usersDeleteServerEndpoint = usersDeleteRoute.handle(user => input => UserHandler.handleUserDelete(user))

        val plaidItemsGetRoute = protectedApiRouteGroup
            .get
            .in("plaid-items" / "list")
            .out(jsonBody[DTOs.PlaidItemsGetResponse])

        val plaidItemsGetServerEndpoint = plaidItemsGetRoute
            .handle(user => _ => PlaidItemHandler.handlePlaidItemsGet(user))

        val plaidItemsCreateRoute = protectedApiRouteGroup
            .post
            .in("plaid-items" / "create")
            .in(jsonBody[DTOs.PlaidItemCreateRequest])
            .out(jsonBody[DTOs.PlaidItemCreateResponse])

        val plaidItemsCreateServerEndpoint = plaidItemsCreateRoute
            .handle(user => input => PlaidItemHandler.handlePlaidItemsCreate(user, input))

        val plaidItemsDeleteRoute = protectedApiRouteGroup
            .delete
            .in("plaid-items" / "delete")
            .in(jsonBody[DTOs.PlaidItemDeleteRequest])

        val plaidItemsDeleteServerEndpoint = plaidItemsDeleteRoute
            .handle(user => input => PlaidItemHandler.handlePlaidItemsDelete(user, input))

        val plaidItemsSyncRoute = protectedApiRouteGroup
            .post
            .in("plaid-items" / "sync")
            .in(jsonBody[DTOs.PlaidItemSyncRequest])

        val plaidItemsSyncServerEndpoint = plaidItemsSyncRoute
            .handle(user => input => PlaidItemHandler.handlePlaidItemsSync(user, input))

        val plaidLinksCreateEndpoint = protectedApiRouteGroup
            .post
            .in("plaid-links" / "create")
            .out(jsonBody[DTOs.PlaidLinkCreateResponse])
        val plaidLinkCreateServerEndpoint = plaidLinksCreateEndpoint
            .handle(profile => _ => PlaidLinkHandler.handler(userId = profile.id))

        val webhooksEndpoint = endpoint
            .post
            .in("webhooks" / "plaid")
            .in(stringJsonBody)
            .out(stringBody)
            .handle(rawJson => PlaidWebhookHandler.handleWebhook(rawJson))

        val secureServerEndpoints = List(
            plaidItemsGetServerEndpoint,
            plaidItemsCreateServerEndpoint,
            plaidLinkCreateServerEndpoint,
            plaidItemsDeleteServerEndpoint
        )
        val serverEndpoints = List(indexEndpoint) ++ secureServerEndpoints
        val docEndpoints = SwaggerInterpreter().fromServerEndpoints[Identity](serverEndpoints, "finny-api", "1.0.0")
        val metricsEndpoint: ServerEndpoint[Any, Identity] = PrometheusMetrics.default[Identity]().metricsEndpoint
        val all =
            serverEndpoints ++ docEndpoints ++ List(metricsEndpoint, webhooksEndpoint, plaidItemsSyncServerEndpoint)

        all

    case class AuthConfig(jwtSecret: String, jwtIssuer: String)

    private def makeAuthenticator(authConfig: AuthConfig): AuthenticationToken => Either[AuthenticationError, Profile] =
        val algorithm = Algorithm.HMAC256(authConfig.jwtSecret)
        (token: AuthenticationToken) =>
            val verifier = JWT.require(algorithm).withIssuer(authConfig.jwtIssuer).build()
            val decodedJwt = Try(verifier.verify(token.value))
            decodedJwt match
                case Success(jwt) =>
                    val userId = UUID.fromString(jwt.getSubject())
                    ProfileRepository.getProfileByUserId(userId) match
                        case Failure(error) =>
                            Logger.root.error(s"Error fetching profile by user id", error)
                            Left(AuthenticationError(500))
                        case Success(None) =>
                            Left(AuthenticationError(404))
                        case Success(Some(Profile(id))) =>
                            Right(Profile(id = userId))
                case Failure(error) =>
                    Logger.root.error(s"Error decoding JWT", error)
                    Left(AuthenticationError(400))
