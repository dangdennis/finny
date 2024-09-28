package test.services

import api.services.FinalyticsService
import org.scalatest.BeforeAndAfterAll
import org.scalatest.BeforeAndAfterEach
import org.scalatest.EitherValues
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import test.helpers.*
import scala.sys.process.*
import java.io.File
import api.repositories.TransactionRepository
import java.util.UUID

// pg_dump -h aws-0-us-east-1.pooler.supabase.com -d postgres -U postgres.tqonkxhrucymdyndpjzf -p 6543 -W -F c -b -v -f output_file.dump
// pg_restore -h localhost -d postgres -U postgres -p 54322 -v supabase_prod_db.dump

class FinalyticsServiceSpec extends AnyFlatSpec, Matchers, EitherValues, BeforeAndAfterAll, BeforeAndAfterEach:

  override protected def beforeAll(): Unit = 
    TestHelper.beforeAll()
  
  override protected def beforeEach(): Unit = 
    restoreDatabase()

  override protected def afterEach(): Unit = TestHelper.afterEach()

  private def restoreDatabase(): Unit =
    val dumpFile = File("src/test/services/supabase_prod_db.dump")
    val dbName = "postgres"
    val command = s"pg_restore -d $dbName ${dumpFile.getAbsolutePath}"
    
    val exitCode = command.run().exitValue()
    if exitCode != 0 then
      throw RuntimeException(s"Failed to restore database. Exit code: $exitCode")

  "calculateRetirementSavingsForCurrentMonth" should "return the correct retirement savings for the current month" in:
    // given

    // hardcoded to dennis user id because we use a dump of the prod database
    val userId = "5eaa8ae7-dbcb-445e-8058-dbd51a912c8d"
    val transactions = TransactionRepository.getTransactionsByAccountId(UUID.fromString("495f3ee1-6187-4dcb-98a4-f6fa4b01b0b9")).value
    assert(transactions.length == )
    // ... rest of your test code ...
