val tapirVersion = "1.10.8"

lazy val rootProject = (project in file(".")).settings(
  Seq(
    name := "api",
    version := "0.1.0-SNAPSHOT",
    organization := "belmont",
    scalaVersion := "3.4.2",
    libraryDependencies ++= Seq(
      "com.softwaremill.sttp.tapir" %% "tapir-netty-server-sync" % tapirVersion,
      "com.softwaremill.sttp.tapir" %% "tapir-prometheus-metrics" % tapirVersion,
      "com.softwaremill.sttp.tapir" %% "tapir-swagger-ui-bundle" % tapirVersion,
      "com.softwaremill.sttp.tapir" %% "tapir-json-upickle" % tapirVersion,
      "com.softwaremill.sttp.tapir" %% "tapir-sttp-stub-server" % tapirVersion % Test,
      "org.scalatest" %% "scalatest" % "3.2.16" % Test,
      "com.softwaremill.sttp.client3" %% "upickle" % "3.8.15" % Test
    )
  )
)