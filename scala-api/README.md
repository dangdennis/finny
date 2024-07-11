## Quick start

## Installation
1. Install [scala](https://www.scala-lang.org/download/)
2. Install [bun](https://bun.sh)

If you don't have [sbt](https://www.scala-sbt.org) installed already, you can use the provided wrapper script:

```shell
./sbtx -h # shows an usage of a wrapper script
./sbtx compile # build the project
./sbtx test # run the tests
./sbtx run # run the application (Main)
```

For more details check the [sbtx usage](https://github.com/dwijnand/sbt-extras#sbt--h) page.

Otherwise, if sbt is already installed, you can use the standard commands:

```shell
sbt compile # build the project
sbt test # run the tests
sbt run # run the application (Main)
```

## Links:

* [tapir documentation](https://tapir.softwaremill.com/en/latest/)
* [tapir github](https://github.com/softwaremill/tapir)
* [bootzooka: template microservice using tapir](https://softwaremill.github.io/bootzooka/)
* [sbtx wrapper](https://github.com/dwijnand/sbt-extras#installation)

## Troubleshooting

```
# If mill can't build due to incorrect java version

export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

```

## Infrastructure
* [LavinMQ](https://lavinmq.com/documentation/installation-guide) - `brew install cloudamqp/cloudamqp/lavinmq`
* [Supabase](https://supabase.com/docs/guides/cli/getting-started) `brew install supabase/tap/supabase`
* [Fly](https://fly.io)
* [Ngrok](https://dashboard.ngrok.com/get-started/setup/macos)