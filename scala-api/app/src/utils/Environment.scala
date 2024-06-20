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
      case "production" => AppEnv.Production
      case _ => AppEnv.Development

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

  def getJwtSecret: String =
    getEnv("JWT_SECRET", "super-secret-jwt-token-with-at-least-32-characters-long")

  def getJwtIssue: String =
    getAppEnv match
      case AppEnv.Development => "http://127.0.0.1:54321/auth/v1"
      case AppEnv.Production => "https://tqonkxhrucymdyndpjzf.supabase.co/auth/v1"

  private def getDatabaseUrl: String =
    getEnv("DATABASE_URL", "jdbc:postgresql://postgres:postgres@127.0.0.1:54322/postgres")

  

    // val jwtSecret = "09sUFObcLZHvtRvj5LBqtQomVPuVqOAa/LW2hcdQqyxCwpH9JDOGPwmn6XHMpaxqUPfRWkxTgiB9i4rb1Vwxwg=="
    // ConnectionPool.singleton(
    //   "jdbc:postgresql://aws-0-us-east-1.pooler.supabase.com:6543/postgres",
    //   "postgres.tqonkxhrucymdyndpjzf",
    //   "I07R6V4POCTi5wd4"
    // )
    // val verifier = JWT.require(algorithm).withIssuer("https://tqonkxhrucymdyndpjzf.supabase.co/auth/v1").build();