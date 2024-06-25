package app.utils.logger

import ch.qos.logback.classic.Level
import ch.qos.logback.classic.Logger
import org.slf4j.LoggerFactory
import io.sentry.Sentry
import app.utils.Environment
import ch.qos.logback.core.ConsoleAppender
import ch.qos.logback.classic.spi.ILoggingEvent
import ch.qos.logback.classic.encoder.PatternLayoutEncoder
import io.sentry.logback.SentryAppender

object Logger:
  def root: Logger =
    LoggerFactory.getLogger(org.slf4j.Logger.ROOT_LOGGER_NAME).asInstanceOf[Logger]

  def db: Logger =
    LoggerFactory.getLogger("db").asInstanceOf[Logger]
  
  def configureLogging(): Unit =
    Sentry.init(options =>
      options.setDsn(Environment.getSentryDsn)
      Environment.getAppEnv match
        case Environment.AppEnv.Development =>
          options.setEnvironment("development")
          options.setTracesSampleRate(1.0)
          options.setEnabled(false)
        case Environment.AppEnv.Production =>
          options.setEnvironment("production")
          options.setTracesSampleRate(0.5)
          options.setEnabled(true)
    )

    val loggerContext = LoggerFactory.getILoggerFactory.asInstanceOf[ch.qos.logback.classic.LoggerContext]

    // Set up the ConsoleAppender
    val consoleAppender = new ConsoleAppender[ILoggingEvent]()
    consoleAppender.setContext(loggerContext)
    val encoder = new PatternLayoutEncoder()
    encoder.setContext(loggerContext)
    encoder.setPattern("%d{yyyy-MM-dd HH:mm:ss} %-5level %logger{36} - %msg%n")
    encoder.start()
    consoleAppender.setEncoder(encoder)
    consoleAppender.start()

    // Set up the SentryAppender
    val sentryAppender = new SentryAppender()
    sentryAppender.setContext(loggerContext)
    sentryAppender.start()

    // Set the root logger level to INFO
    val rootLogger = loggerContext.getLogger(org.slf4j.Logger.ROOT_LOGGER_NAME).asInstanceOf[Logger]
    rootLogger.setLevel(Level.INFO)

    // Set the db logger level to WARN
    val dbLogger = loggerContext.getLogger("db").asInstanceOf[Logger]
    dbLogger.setLevel(Level.WARN)