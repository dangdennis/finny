val tapirVersion = "1.10.6"

lazy val rootProject = (project in file(".")).settings(
  Seq(
    name := "finny-api",
    version := "0.1.0-SNAPSHOT",
    organization := "com.belmont",
    scalaVersion := "3.3.3",
    libraryDependencies ++= Seq(
      "com.softwaremill.sttp.tapir" %% "tapir-netty-server-sync" % tapirVersion,
      "com.softwaremill.sttp.tapir" %% "tapir-prometheus-metrics" % tapirVersion,
      "com.softwaremill.sttp.tapir" %% "tapir-swagger-ui-bundle" % tapirVersion,
      "com.softwaremill.sttp.tapir" %% "tapir-json-upickle" % tapirVersion,
      "ch.qos.logback" % "logback-classic" % "1.5.6",
      "com.softwaremill.sttp.tapir" %% "tapir-sttp-stub-server" % tapirVersion % Test,
      "org.scalatest" %% "scalatest" % "3.2.18" % Test,
      "com.softwaremill.sttp.client3" %% "upickle" % "3.9.6" % Test
    )
  )
)
