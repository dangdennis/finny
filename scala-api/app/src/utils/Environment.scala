package app.utils

object Environment:
  enum AppEnv:
    case Development, Production

  private def getEnv(key: String, default: String): String =
    sys.env.getOrElse(key, default)

  private def getEnv(key: String): Option[String] =
    sys.env.get(key)

  def getAppEnv: AppEnv =
    getEnv("APP_ENV", "development") match
      case "development" => AppEnv.Development
      case "production"  => AppEnv.Production
      case _             => sys.error("Invalid APP_ENV. Expected: development or production")

  def getPort: Int =
    getEnv("HTTP_PORT").flatMap(_.toIntOption).getOrElse(8080)

  case class DatabaseConfig(url: String, user: String, password: String)

  def getDatabaseConfig: DatabaseConfig =
    val pattern = """jdbc:postgresql://([^:]+):([^@]+)@([^/]+/[^?]+)""".r

    getDatabaseUrl match
      case pattern(username, password, restUrl) =>
        DatabaseConfig(url = s"jdbc:postgresql://$restUrl", user = username, password = password)
      case _ =>
        sys.error("Invalid database URL format. Expected: jdbc:postgresql://username:password@host:port/database")

  private def getDatabaseUrl: String =
    getEnv("DATABASE_URL", "jdbc:postgresql://postgres:postgres@127.0.0.1:54322/postgres")

  def getJwtSecret: String =
    getEnv("JWT_SECRET", "super-secret-jwt-token-with-at-least-32-characters-long")

  def getJwtIssue: String =
    getAppEnv match
      case AppEnv.Development => "http://127.0.0.1:54321/auth/v1"
      case AppEnv.Production  => "https://tqonkxhrucymdyndpjzf.supabase.co/auth/v1"

  def getLavinMQUrl: String =
    getEnv("LAVIN_MQ_URL", "amqp://guest:guest@localhost:5672")

  def getSentryDsn: String =
    getEnv("SENTRY_DSN", "https://411fd1489713d981f19699e49abc5c6a@o4507494754746368.ingest.us.sentry.io/4507494821003264")

  def getBaseUrl: String =
    getAppEnv match
      case _ => "https://finny-backend.fly.dev"

  def getPlaidClientId: String =
    getEnv("PLAID_CLIENT_ID", "661ac9375307a3001ba2ea46")

  def getPlaidSecret: String =
    getEnv("PLAID_SECRET", "57ebac97c0bcf92f35878135d68793")