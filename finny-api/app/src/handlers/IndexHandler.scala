package app.handlers



object IndexHandler:
  def handler(): Either[Unit, String] =
    Right("Hello world!")
