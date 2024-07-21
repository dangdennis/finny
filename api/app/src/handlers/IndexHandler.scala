package app.handlers

object IndexHandler:
    def handleIndex(): Either[Unit, String] = Right("Hello world!")
