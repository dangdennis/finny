import mill._, scalalib._

object app extends ScalaModule {
  def scalaVersion = "3.4.2"

  def ivyDeps = Agg(
    ivy"com.softwaremill.sttp.tapir::tapir-netty-server-sync:1.10.6",
    ivy"com.softwaremill.sttp.tapir::tapir-prometheus-metrics:1.10.6",
    ivy"com.softwaremill.sttp.tapir::tapir-swagger-ui-bundle:1.10.6",
    ivy"com.softwaremill.sttp.tapir::tapir-json-upickle:1.10.6",
    ivy"ch.qos.logback:logback-classic:1.5.6",
    ivy"com.plaid:plaid-java:23.0.0"
  )

  object test extends ScalaTests with TestModule.Utest {
    def ivyDeps = Agg(
      ivy"com.softwaremill.sttp.tapir::tapir-sttp-stub-server:1.10.6",
      ivy"org.scalatest::scalatest:3.2.18",
      ivy"com.softwaremill.sttp.client3::upickle:3.9.6"
    )
  }
}
