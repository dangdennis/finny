import mill._, scalalib._
import $ivy.`com.goyeau::mill-scalafix::0.4.0`
import com.goyeau.mill.scalafix.ScalafixModule

object app extends ScalaModule with ScalafixModule {
  def scalaVersion = "3.4.2"

  def ivyDeps = Agg(
    ivy"com.softwaremill.sttp.tapir::tapir-core:1.10.8",
    ivy"com.softwaremill.sttp.tapir::tapir-nima-server:1.10.8",
    ivy"com.softwaremill.sttp.tapir::tapir-prometheus-metrics:1.10.8",
    ivy"com.softwaremill.sttp.tapir::tapir-swagger-ui-bundle:1.10.8",
    ivy"com.softwaremill.sttp.tapir::tapir-json-upickle:1.10.8",
    ivy"com.plaid:plaid-java:23.0.0",
    ivy"com.softwaremill.sttp.client3::upickle:3.9.6",
    ivy"ch.qos.logback:logback-classic:1.5.6",
    ivy"org.postgresql:postgresql::42.2.18",
    ivy"org.scalikejdbc::scalikejdbc:4.3.0",
    ivy"com.auth0:java-jwt:4.4.0",
    ivy"io.sentry:sentry-logback:8.0.0-alpha.1",
    ivy"io.github.resilience4j:resilience4j-ratelimiter:2.2.0",
    ivy"io.github.resilience4j:resilience4j-retry:2.2.0"
  )

  object test extends ScalaTests with TestModule.ScalaTest with ScalafixModule {
    def ivyDeps = Agg(
      ivy"com.softwaremill.sttp.tapir::tapir-sttp-stub-server:1.10.8",
      ivy"org.scalatest::scalatest:3.2.18",
      ivy"org.testcontainers:testcontainers:1.19.8"
    )
  }

  // Add Scala compiler options
  def scalacOptions = T {
    super.scalacOptions() ++ Seq(
      "-Wunused:imports"
    )
  }
}

// Create a new script module that uses the dependencies from app
object scripts extends ScalaModule {
  def scalaVersion = "3.4.2"
  
  // Use the sources from the scripts directory at the root
  override def sources = T.sources { millSourcePath / "scripts" / "src" }

  // Depend on the app module to reuse its dependencies
  override def moduleDeps = Seq(app)

  def mainClass = Some("scripts.UpdatePlaidItemsWebhook")
}