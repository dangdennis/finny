import mill._, scalalib._
import $ivy.`com.goyeau::mill-scalafix::0.4.0`
import com.goyeau.mill.scalafix.ScalafixModule

object app extends ScalaModule with ScalafixModule with scalafmt.ScalafmtModule {
    def scalaVersion = "3.4.2"

    def scalacOptions = T {
        super.scalacOptions() ++ Seq(
            "-Wunused:imports"
        )
    }

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
        ivy"io.github.resilience4j:resilience4j-retry:2.2.0",
        ivy"com.rabbitmq:amqp-client:5.21.0"
    )

    object test extends ScalaTests with TestModule.ScalaTest with ScalafixModule with scalafmt.ScalafmtModule {
        def ivyDeps = Agg(
            ivy"com.softwaremill.sttp.tapir::tapir-sttp-stub-server:1.10.8",
            ivy"org.scalatest::scalatest:3.2.18",
            ivy"org.testcontainers:testcontainers:1.19.8"
        )
    }

}

object cli extends ScalaModule with ScalafixModule with scalafmt.ScalafmtModule {
    def scalaVersion = "3.4.2"

    override def scalacOptions = T {
        super.scalacOptions() ++ Seq(
            "-Wunused:imports"
        )
    }

    override def moduleDeps = Seq(app)

}

object all extends Module {
    def scalaVersion = "3.4.2"

    def compile() = T.command {
        app.compile()
        app.test.compile()
        cli.compile()
    }

    def fix() = T.command {
        app.fix()
        app.test.fix()
        cli.fix()
    }

    def reformat() = T.command {
        app.reformat()
        app.test.reformat()
        cli.reformat()
    }
}
