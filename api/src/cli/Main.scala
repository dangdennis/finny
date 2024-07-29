package cli

import api.common.Environment
import api.common.Environment.AppEnv
import api.database.Database
import api.models.PlaidItemId
import api.services.PlaidService

import java.util.UUID

object Cli {
    @main
    def main(args: String*): Unit =
        val config = Environment.DatabaseConfig(
            host = "jdbc:postgresql://aws-0-us-east-1.pooler.supabase.com:6543/postgres",
            user = "postgres.tqonkxhrucymdyndpjzf",
            password = "x"
        )
        Database.init(config)
        println("Database initialized")
        val plaidClient = PlaidService
            .makePlaidClient(clientId = "661ac9375307a3001ba2ea46", secret = "x", env = AppEnv.Production)

        args match
            case Seq() =>
                println("Please provide a command")
            case command :: itemId :: _ =>
                command match
                    case "delete-item" =>
                        val results =
                            for res <- PlaidService
                                    .deleteItem(client = plaidClient, itemId = PlaidItemId(UUID.fromString(itemId)))
                            yield res
                        println(results)
                    case _ =>
                        println("Unknown command")
}
