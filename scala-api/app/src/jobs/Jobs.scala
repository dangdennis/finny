package app.jobs
import java.util.UUID

object Jobs:
    def init() = ()

case class Job(id: UUID = UUID.randomUUID(), name: String, data: String)
