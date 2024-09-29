package test.services

// import api.services.FinalyticsService
import org.scalatest.flatspec.AnyFlatSpec
import test.helpers.*

import java.io.File
import scala.sys.process.*

// export PGPASSWORD=postgres && pg_restore -h localhost -d postgres -U postgres -p 5432 -v src/test/services/supabase_prod_db.dump

class FinalyticsServiceSpec extends TestInfra:
  override protected def beforeEach(): Unit =
    super.beforeEach()
    restoreDatabase()

  private def restoreDatabase(): Unit =
    val dumpFile = File("src/test/services/supabase_prod_db.dump")
    val dbName = "postgres"
    val command = s"pg_restore -d $dbName ${dumpFile.getAbsolutePath}"

    val exitCode = command.run().exitValue()
    if exitCode != 0 then
      throw RuntimeException(
        s"Failed to restore database. Exit code: $exitCode"
      )

  // "calculateRetirementSavingsForCurrentMonth" should "return the correct retirement savings for the current month" in:
  //   // given
  //   // hardcoded to dennis user id because we use a dump of the prod database
  //   val userId = "5eaa8ae7-dbcb-445e-8058-dbd51a912c8d"
  //   val transactions = TransactionRepository
  //     .getTransactionsByAccountId(
  //       UUID.fromString("495f3ee1-6187-4dcb-98a4-f6fa4b01b0b9")
  //     )
  //     .value
  //   assert(transactions.length == 337)
  //   // ... rest of your test code ...
