package cli

import api.common.Environment
import api.common.Environment.AppEnv
import api.database.DatabaseJdbc
import api.models.PlaidItemId
import api.services.PlaidService

import java.util.UUID

object Cli {
  @main
  def main(args: String*): Unit =
    val config = Environment.DatabaseConfig(
      host =
        "jdbc:postgresql://aws-0-us-east-1.pooler.supabase.com:6543/postgres",
      user = "postgres.tqonkxhrucymdyndpjzf",
      password = "I07R6V4POCTi5wd4"
    )
    DatabaseJdbc.init(config)
    println("Database initialized")
    val plaidClient = PlaidService
      .makePlaidClient(
        clientId = "661ac9375307a3001ba2ea46",
        secret = "b7cdf3790e64dffb46b4edd1762f70",
        env = AppEnv.Production
      )

    args match
      case Seq() =>
        println("Please provide a command")
      case command :: remainingArgs =>
        command match
          case "delete-item" =>
            remainingArgs match
              case itemId :: userId :: _ =>
                val results =
                  for res <- PlaidService.deleteItem(
                      client = plaidClient,
                      itemId = PlaidItemId(UUID.fromString(itemId)),
                      userId = UUID.fromString(userId)
                    )
                  yield res
                println(results)
              case _ =>
                println("Invalid arguments for delete-item command")
          case "investment-transactions" =>
            remainingArgs match
              case itemId :: _ =>
                val results =
                  for res <- PlaidService.getInvestmentTransactions(
                      client = plaidClient,
                      itemId = PlaidItemId(UUID.fromString(itemId))
                    )
                  yield res
                println(results)
              case _ =>
                println("Invalid arguments for investment-transactions command")
          case _ =>
            println("Unknown command")
}
