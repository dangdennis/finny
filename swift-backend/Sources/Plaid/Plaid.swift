
import OpenAPIRuntime
import OpenAPIAsyncHTTPClient
import Foundation

struct HelloWorldAsyncHTTPClient {
    static func method1() async throws {
        let client = Client(serverURL: URL(string: "http://localhost:8080/api")!, transport: AsyncHTTPClientTransport())
        // let response = try await client.get
        // print(try response.ok.body.json.message)
    }
}