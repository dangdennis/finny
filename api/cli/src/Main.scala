package cli

import app.common.Environment
import app.common.Environment.AppEnv
import app.database.Database
import app.repositories.PlaidItemRepository
import app.services.PlaidService

object Cli {
    @main def main(args: String*): Unit =
        args match
            case Seq() => println("Please provide a command")
            case command :: _ =>
                command match
                    case "delete-all-plaid-items" =>
                        val config = Environment.DatabaseConfig(
                            host = "jdbc:postgresql://aws-0-us-east-1.pooler.supabase.com:6543/postgres",
                            user = "postgres.tqonkxhrucymdyndpjzf",
                            password = "I07R6V4POCTi5wd4"
                        )

                        val results = for
                            _ <- Database.init(config)
                            _ = println("Database initialized")
                            items <- PlaidItemRepository.getItems()
                        yield items

                        results match
                            case Right(items) =>
                                println(s"Items: $items")
                                items
                                    .map(item =>
                                        PlaidService.removeItem(
                                            client = PlaidService.makePlaidClient(
                                                clientId = "661ac9375307a3001ba2ea46",
                                                secret = "b7cdf3790e64dffb46b4edd1762f70",
                                                env = AppEnv.Production
                                            ),
                                            itemId = item.id
                                        )
                                    ).foreach(println)
                            case Left(error) =>
                                println(s"Error: $error")

                    case "update-all-plaid-items-webhook" =>
                        println("Goodbye, world!")
                    case _ => println("Unknown command")
}
