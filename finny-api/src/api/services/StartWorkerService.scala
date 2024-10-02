package api.services

import sttp.client4.quick.*

object StartWorkerService:
  def requestWorkerStart(): Unit =
    quickRequest
      .post(uri"https://finny-worker.fly.dev/start")
      .send()
