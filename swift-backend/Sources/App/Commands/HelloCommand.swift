import Vapor

struct HelloCommand: AsyncCommand {
    struct Signature: CommandSignature { @Argument(name: "name") var name: String }

    var help: String { "Says hello" }

    func run(using context: CommandContext, signature: Signature) async throws {
        let name = context.console.ask("What is your \("name", color: .blue)?")
        context.console.print("Hello, \(name) 👋")
    }
}
