package app.common

object Time:
    def now(): java.time.Instant = java.time.Instant.now().truncatedTo(java.time.temporal.ChronoUnit.MICROS)