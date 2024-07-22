package api.models

import java.util.UUID
import java.time.Instant

case class Profile(id: UUID, deletedAt: Option[Instant] = None)
