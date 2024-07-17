package app.common

import java.net.URI

object Environment:
    enum AppEnv:
        case Development, Production

    private def getEnv(
        key: String,
        default: String
    ): String =
        sys.env.getOrElse(key, default)

    def getAppEnv: AppEnv =
        sys.env.getOrElse(
            "APP_ENV",
            "development"
        ) match
            case "development" =>
                AppEnv.Development
            case "production" =>
                AppEnv.Production
            case _ =>
                sys.error(
                    "Invalid APP_ENV. Expected: development or production"
                )

    def appEnvToString(
        appEnv: AppEnv
    ): String =
        appEnv match
            case AppEnv.Development =>
                "development"
            case AppEnv.Production =>
                "production"

    def getPort: Int =
        sys.env
            .get("HTTP_PORT")
            .flatMap(_.toIntOption)
            .getOrElse(8080)

    case class DatabaseConfig(
        host: String,
        user: String,
        password: String
    )

    def getDatabaseConfig: DatabaseConfig =
        val pattern =
            """jdbc:postgresql://([^:]+):([^@]+)@([^/]+/[^?]+)""".r

        getDatabaseUrl match
            case pattern(
                    username,
                    password,
                    restUrl
                ) =>
                DatabaseConfig(
                    host = s"jdbc:postgresql://$restUrl",
                    user = username,
                    password = password
                )
            case _ =>
                sys.error(
                    "Invalid database URL format. Expected: jdbc:postgresql://username:password@host:port/database"
                )

    private def getDatabaseUrl: String =
        getAppEnv match
            case AppEnv.Production =>
                sys.env
                    .get("DATABASE_URL")
                    .get
            case AppEnv.Development =>
                "jdbc:postgresql://postgres:postgres@127.0.0.1:54322/postgres"

    def getJwtSecret: String =
        getAppEnv match
            case AppEnv.Production =>
                sys.env
                    .get("JWT_SECRET")
                    .get
            case AppEnv.Development =>
                "super-secret-jwt-token-with-at-least-32-characters-long"

    def getJwtIssue: String =
        getAppEnv match
            case AppEnv.Development =>
                "http://127.0.0.1:54321/auth/v1"
            case AppEnv.Production =>
                "https://tqonkxhrucymdyndpjzf.supabase.co/auth/v1"

    def getSentryDsn: String =
        getAppEnv match
            case AppEnv.Production =>
                sys.env
                    .get("SENTRY_DSN")
                    .get
            case AppEnv.Development =>
                "https://411fd1489713d981f19699e49abc5c6a@o4507494754746368.ingest.us.sentry.io/4507494821003264"

    def getBaseUrl: String =
        getAppEnv match
            case AppEnv.Production =>
                "https://api.finny.finance"
            case AppEnv.Development =>
                "https://chamois-expert-stingray.ngrok-free.app"

    def getPlaidClientId: String =
        getAppEnv match
            case AppEnv.Production =>
                sys.env
                    .get(
                        "PLAID_CLIENT_ID"
                    )
                    .get
            case AppEnv.Development =>
                "661ac9375307a3001ba2ea46"

    def getPlaidSecret: String =
        getAppEnv match
            case AppEnv.Production =>
                sys.env
                    .get("PLAID_SECRET")
                    .get
            case AppEnv.Development =>
                "57ebac97c0bcf92f35878135d68793"

    def getLavinMqUrl: URI =
        getAppEnv match
            case AppEnv.Production =>
                URI(
                    sys.env
                        .get(
                            "LAVIN_MQ_URL"
                        )
                        .get
                )
            case AppEnv.Development =>
                URI(
                    "amqp://guest:guest@localhost:5672"
                )
