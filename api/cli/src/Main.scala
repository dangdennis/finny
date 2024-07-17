package cli

import app.common.Environment
import app.common.Environment.AppEnv
import app.database.Database
import app.services.PlaidService

import java.util.UUID

object Cli {
    @main def main(args: String*): Unit =
        val config = Environment.DatabaseConfig(
            host = "jdbc:postgresql://aws-0-us-east-1.pooler.supabase.com:6543/postgres",
            user = "postgres.tqonkxhrucymdyndpjzf",
            password = "I07R6V4POCTi5wd4"
        )
        Database.init(config)
        println("Database initialized")
        val plaidClient = PlaidService.makePlaidClient(
            clientId = "661ac9375307a3001ba2ea46",
            secret = "b7cdf3790e64dffb46b4edd1762f70",
            env = AppEnv.Production
        )

        args match
            case Seq() => println("Please provide a command")
            case command :: itemId :: _ =>
                command match
                    case "delete-item" =>
                        val results =
                            for res <- PlaidService
                                    .removeItem(
                                        client = plaidClient,
                                        itemId = UUID.fromString(
                                            itemId
                                        )
                                    )
                            yield res
                        println(results)
                    case _ => println("Unknown command")
}
