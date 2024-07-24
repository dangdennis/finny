package api.common

object Time:
    def now(): java.time.Instant = java.time.Instant.now().truncatedTo(java.time.temporal.ChronoUnit.MICROS)
    def nowUtc() = java
        .time
        .Instant
        .now()
        .truncatedTo(java.time.temporal.ChronoUnit.MICROS)
        .atOffset(java.time.ZoneOffset.UTC)
