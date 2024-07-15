package cli

object Cli {
    @main def main(args: String*): Unit =
        args match
            case Seq() => println("Hello, world!")
            case command :: _ =>
                command match
                    case "hello"   => println("Hello, world!")
                    case "goodbye" => println("Goodbye, world!")
                    case _         => println("Hello, world!")
}
