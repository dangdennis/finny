package app.repositories

import scalasql._
import scalasql.PostgresDialect._
import java.sql.{Connection, DriverManager}

object UserRepository {
  case class User[T[_]](
      id: T[String],
      email: T[Option[String]]
  )

  object User extends Table[User]() {
    override def tableName: String = "auth.users"
  }

  def getUsers(): Unit = {
    println("get users start")
    
    val dbClient = new DbClient.Connection(
      java.sql.DriverManager
        .getConnection(
          "jdbc:postgresql://fly-0-ewr.pooler.supabase.com:6543/postgres?user=postgres.ogagpskctstoizavqalo&password=EzixzyhmYtIy5216"
        ),
      new Config {
        override def nameMapper(v: String) = v.toLowerCase()
      }
    )

    println("connect to postgres")
    println(dbClient)

    val db = dbClient.getAutoCommitClientConnection
    val query = User.select
    val sql = db.renderSql(query)
    println(sql)

    val results = db.run(query)
    println(results)

    ()
  }
}
