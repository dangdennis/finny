import mill._, scalalib._
import $ivy.`com.goyeau::mill-scalafix::0.4.0`
import com.goyeau.mill.scalafix.ScalafixModule
import mill.scalalib.scalafmt.ScalafmtModule

trait CommonModule extends ScalaModule with ScalafixModule with scalafmt.ScalafmtModule {
    def scalaVersion = "3.5.0"

    def scalacOptions = T {
        Seq("-Wunused:imports", "-feature", "-deprecation", "-language:implicitConversions")
    }

    def ivyDeps = Agg(
        ivy"com.softwaremill.sttp.tapir::tapir-core:1.10.8",
        ivy"com.softwaremill.sttp.tapir::tapir-nima-server:1.10.8",
        ivy"com.softwaremill.sttp.tapir::tapir-prometheus-metrics:1.10.8",
        ivy"com.softwaremill.sttp.tapir::tapir-swagger-ui-bundle:1.10.8",
        ivy"com.softwaremill.sttp.tapir::tapir-json-circe:1.10.8",
        ivy"com.plaid:plaid-java:23.0.0",
        ivy"com.softwaremill.sttp.client3::core:3.9.7",
        ivy"com.softwaremill.sttp.client3::circe:3.9.7",
        ivy"ch.qos.logback:logback-classic:1.5.6",
        ivy"org.postgresql:postgresql::42.2.18",
        ivy"org.scalikejdbc::scalikejdbc:4.3.0",
        ivy"com.auth0:java-jwt:4.4.0",
        ivy"io.sentry:sentry-logback:8.0.0-alpha.1",
        ivy"io.github.resilience4j:resilience4j-ratelimiter:2.2.0",
        ivy"io.github.resilience4j:resilience4j-retry:2.2.0",
        ivy"com.rabbitmq:amqp-client:5.21.0",
        ivy"com.softwaremill.sttp.tapir:tapir-json-circe_3:1.10.14",
        ivy"io.circe:circe-core_3:0.14.9",
        ivy"io.circe:circe-generic_3:0.14.9",
        ivy"io.circe:circe-parser_3:0.14.9",
        ivy"io.helidon.webserver:helidon-webserver-access-log:4.0.11"
    )
}

object api extends CommonModule {
    override def sources = T.sources {
        os.pwd / "src" / "api"
    }
}

object test extends TestModule.ScalaTest with CommonModule {
    override def sources = T.sources {
        os.pwd / "src" / "test"
    }

    override def defaultCommandName(): String = super.defaultCommandName()

    override def moduleDeps = Seq(api)

    def ivyDeps =
        super.ivyDeps() ++
            Agg(
                ivy"com.softwaremill.sttp.tapir::tapir-sttp-stub-server:1.10.8",
                ivy"org.scalatest::scalatest:3.2.18",
                ivy"org.testcontainers:testcontainers:1.19.8"
            )
}

object cli extends CommonModule {
    override def sources = T.sources {
        os.pwd / "src" / "cli"
    }

    override def moduleDeps = Seq(api)

}

object all extends CommonModule {
    def compile = T.command {
        api.compile()
        test.compile()
        cli.compile()
    }

    def fix() = T.command {
        api.fix()
        test.fix()
        cli.fix()
    }

    // todo: get this working one day
    def reformat() = T.command {
        api.reformat()
        test.reformat()
        cli.reformat()
    }
}
