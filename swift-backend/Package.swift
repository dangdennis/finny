// swift-tools-version:5.10
import PackageDescription

let package = Package(
  name: "backend",
  platforms: [
    .macOS(.v13)
  ],
  dependencies: [
    // 💧 A server-side Swift web framework.
    .package(url: "https://github.com/vapor/vapor.git", from: "4.92.4"),
    // 🗄 An ORM for SQL and NoSQL databases.
    .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
    // 🐘 Fluent driver for Postgres.
    .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0"),
    // 🍃 An expressive, performant, and extensible templating language built for Swift.
    .package(url: "https://github.com/vapor/leaf.git", from: "4.3.0"),
    // 📦 OpenAPI generator for Swift
    .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.2.1"),
    .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.3.2"),
    .package(url: "https://github.com/swift-server/swift-openapi-async-http-client", from: "1.0.0"),
    .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0"),
  ],
  targets: [
    .executableTarget(
      name: "App",
      dependencies: [
        .product(name: "Fluent", package: "fluent"),
        .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
        .product(name: "Leaf", package: "leaf"),
        .product(name: "Vapor", package: "vapor"),
        .product(name: "JWT", package: "jwt"),
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
        .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
        .target(name: "Plaid"),
      ],
      swiftSettings: swiftSettings
    ),

    .testTarget(
      name: "AppTests",
      dependencies: [
        .target(name: "App"),
        .product(name: "XCTVapor", package: "vapor"),
      ],
      swiftSettings: swiftSettings
    ),

    .target(
      name: "Plaid",
      dependencies: [
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
        .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
      ],
      plugins: [
        .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
      ]
    ),
  ]
)

var swiftSettings: [SwiftSetting] {
  [
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("StrictConcurrency"),
  ]
}
