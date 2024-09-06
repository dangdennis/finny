package api.common

import java.time.Instant
import java.time.LocalDate
import java.time.OffsetDateTime
import java.time.ZoneId

object Time:
  def now(): Instant =
    java.time.Instant.now().truncatedTo(java.time.temporal.ChronoUnit.MICROS)
  def nowUtc(): OffsetDateTime = java.time.Instant
    .now()
    .truncatedTo(java.time.temporal.ChronoUnit.MICROS)
    .atOffset(java.time.ZoneOffset.UTC)
  def toLocalDate(time: Instant): LocalDate =
    time.atZone(java.time.ZoneOffset.UTC).toLocalDate()
  extension (instant: Instant)
    def toLocalDate(zoneId: ZoneId = ZoneId.systemDefault()): LocalDate =
      instant.atZone(zoneId).toLocalDate()
