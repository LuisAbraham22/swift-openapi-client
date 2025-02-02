# SwiftOpenAIClient

A lightweight, type-safe OpenAI API client for Swift built on OpenAPIRuntime and AsyncHTTPClient.

[![Swift](https://img.shields.io/badge/Swift-6.0+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-macOS%20iOS%20tvOS%20watchOS%20visionOS-blue.svg)](https://github.com/apple/swift-openapi-runtime)


## Features

- 🔒 Type-safe API built on Swift's OpenAPIRuntime
- 🌊 Native async/await support
- 📡 Streaming chat completions
- 🛠️ Configurable middleware stack
- ⚡️ Built on AsyncHTTPClient for high performance
- 🔄 Customizable transport layer
- 📱 iOS, macOS, and Linux support

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/LuisAbraham22/swift-openapi-client.git", from: "1.0.0")
]
```

## Quick Start

```swift
import SwiftOpenAIClient

// Initialize with default configuration
let client = OpenAI.client(with: .default(apiKey: "your-api-key"))

// Make a chat completion request
let response = try await client.createChatCompletion(
    body: .json(
        .init(
            messages: [
                .ChatCompletionRequestUserMessage(
                    .init(
                        content: .case1("Hello!"),
                        role: .user
                    )
                )
            ],
            model: .init(value2: .gpt4),
            stream: false
        )
    )
)


// Access the response content
if case .json(let completion) = try response.ok.body {
    print("Assistant's response: \(completion.choices[0].message.content)")
    print("Model used: \(completion.model)")
    print("Total tokens: \(completion.usage?.totalTokens)")
    print("Prompt tokens: \(completion.usage?.promptTokens)")
    print("Completion tokens: \(completion.usage?.completionTokens)")
}
```

## Streaming Support

Handle streaming responses with native async sequences:

```swift
let response = try await client.createChatCompletion(
    body: .json(
        .init(
            messages: [
                .ChatCompletionRequestUserMessage(
                    .init(
                        content: .case1("Explain LLMs briefly"),
                        role: .user
                    )
                )
            ],
            model: .init(value2: .gpt4oMini),
            stream: true
        )
    )
)

typealias ChatGPTPayload = Components.Schemas.CreateChatCompletionStreamResponse

let chatGPTStream = try response.ok.body.textEventStream
    .asDecodedServerSentEventsWithJSONData(
        of: ChatGPTPayload.self,
        while: { $0 != HTTPBody.ByteChunk("[DONE]".utf8) }
    )

for try await message in chatGPTStream {
    print(message.data?.choices[0].delta.content ?? "", terminator: "")
}
```

## Configuration

### Custom Configuration

```swift
let config = OpenAI.Configuration(
    apiKey: "your-api-key",
    baseURL: URL(string: "https://api.openai.com/v1")!,
    transport: AsyncHTTPClientTransport()
)
let client = OpenAI.client(with: config)
```
### Transport Configuration

#### URLSession Transport

First, add the URLSession transport dependency to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/apple/swift-openapi-urlsession", from: "1.0.0")
]

targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
        ]
    )
]
```

Then use it in your configuration:

```swift
import OpenAPIURLSession

let config = OpenAI.Configuration(
    apiKey: "your-api-key",
    baseURL: .openAIBaseURL,
    transport: URLSessionTransport()
)
let client = OpenAI.client(with: config)
```

Implement your own transport layer by conforming to `ClientTransport`:

```swift
struct CustomTransport: ClientTransport {
    func send(_ request: HTTPRequest, body: HTTPBody?) async throws -> (HTTPResponse, HTTPBody?) {
        // Your custom transport implementation
    }
}

let config = OpenAI.Configuration(
    apiKey: "your-api-key",
    baseURL: .openAIBaseURL,
    transport: CustomTransport()
)
```

### Authentication Middleware

The library includes built-in authentication middleware that handles API key management:

```swift
struct AuthenticationMiddleware: ClientMiddleware {
    private let apiKey: String
    
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        request.headerFields[.authorization] = "Bearer \(apiKey)"
        request.headerFields[.contentType] = "application/json"
        return try await next(request, body, baseURL)
    }
}
```

## Best Practices

1. **Error Handling**
   - Always handle potential errors using Swift's native error handling
   - Check response status and handle rate limits appropriately

2. **Resource Management**
   - Use appropriate timeouts for streaming responses
   - Close connections when done with streaming

3. **Configuration**
   - Store API keys securely
   - Consider using environment variables for configuration

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

## Requirements

- Swift 6.0+
- Platforms:
  - macOS 15.0+
  - iOS 13.0+
  - tvOS 13.0+
  - watchOS 6.0+
  - visionOS 1.0+
- Dependencies:
  - OpenAPIRuntime 1.7.0+
  - OpenAPIAsyncHTTPClient 1.0.0+

## License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Acknowledgments

- Built with [Swift OpenAPIRuntime](https://github.com/apple/swift-openapi-runtime)
- Powered by [AsyncHTTPClient](https://github.com/swift-server/async-http-client)

---

Made with ❤️ by Luis Abraham