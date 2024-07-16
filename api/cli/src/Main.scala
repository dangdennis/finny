package cli

import app.services.PlaidService
import app.repositories.PlaidItemRepository
import app.database.Database
import app.common.Environment

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
                            case Left(error) =>
                                println(s"Error: $error")

                    case "update-all-plaid-items-webhook" =>
                        println("Goodbye, world!")
                    case _ => println("Unknown command")
}
