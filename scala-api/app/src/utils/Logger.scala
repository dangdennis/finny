package app.utils.logger

import ch.qos.logback.classic.Level
import ch.qos.logback.classic.Logger
import org.slf4j.LoggerFactory

object LogConfig {
  def configureLogging(): Unit = {
    val loggerContext = LoggerFactory.getILoggerFactory.asInstanceOf[ch.qos.logback.classic.LoggerContext]

    // Set the root logger level to INFO
    val rootLogger = loggerContext.getLogger(org.slf4j.Logger.ROOT_LOGGER_NAME).asInstanceOf[Logger]
    rootLogger.setLevel(Level.INFO)

    // Set the scalikejdbc logger level to WARN
    val scalikejdbcLogger = loggerContext.getLogger("scalikejdbc").asInstanceOf[Logger]
    scalikejdbcLogger.setLevel(Level.WARN)
  }
}
