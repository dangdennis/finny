import mill._, scalalib._

object app extends ScalaModule {
  def scalaVersion = "3.4.2"

  def ivyDeps = Agg(
    ivy"com.lihaoyi::cask:0.9.2",
    ivy"com.plaid:plaid-java:23.0.0",
    ivy"com.lihaoyi::upickle:3.3.1"
  )
  object test extends ScalaTests with TestModule.Utest {

    def ivyDeps = Agg(
      ivy"com.lihaoyi::utest::0.8.1",
      ivy"com.lihaoyi::requests::0.8.0"
    )
  }
}
