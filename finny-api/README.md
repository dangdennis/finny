## Quick start

## Installation
1. Install [scala](https://www.scala-lang.org/download/)
2. Install mill `brew install mill` or you can just use `./mill`

## Development
1. Run `docker compose up` to start the queue.
2. Run `supabase start`.
3. Run `make r` to start the server in watch mode.

## Production
1. Run `make deploy` to deploy to Fly.
2. A GH action is setup to deploy main to production on merge.

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
* [Zulu JDK 21](https://www.azul.com/downloads/#zulu)
* [LavinMQ](https://lavinmq.com/documentation/installation-guide) - `brew install cloudamqp/cloudamqp/lavinmq`
* [Supabase](https://supabase.com/docs/guides/cli/getting-started) `brew install supabase/tap/supabase`
* [Fly](https://fly.io)
* [Ngrok](https://dashboard.ngrok.com/get-started/setup/macos)
