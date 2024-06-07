package app

object MinimalApplication extends cask.MainRoutes {
  override def port: Int = 8080
  override def host: String = "0.0.0.0"

  @cask.get("/")
  def hello() = {
    "Hello World!"
  }

  @cask.post("/do-thing")
  def doThing(request: cask.Request) = {
    request.text().reverse
  }

  // Main method to start the application and print the host and port
  override def main(args: Array[String]): Unit = {
    super.initialize()
    println(s"Server is running on http://$host:$port")
    super.main(args)
  }

}
