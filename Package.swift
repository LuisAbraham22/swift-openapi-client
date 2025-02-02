// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftOpenAIClient",
    platforms: [.macOS(.v15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .visionOS(.v1)],
    products: [
        .library(
            name: "OpenAIClient",
            targets: ["SwiftOpenAIClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.6.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.7.0"),
        .package(url: "https://github.com/swift-server/swift-openapi-async-http-client", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(name: "Examples",
                          dependencies: [
                            .target(name: "SwiftOpenAIClient")
                          ]),
        
            .target(
                name: "SwiftOpenAIClient",
                dependencies: [
                    .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                    .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                ]
            ),
        .testTarget(
            name: "SwiftOpenAIClientTests",
            dependencies: ["SwiftOpenAIClient"]
        ),
    ]
)
