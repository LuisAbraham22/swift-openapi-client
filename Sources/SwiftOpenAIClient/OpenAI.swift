import Foundation
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime

public struct OpenAI {
    package static let baseURLString = "https://api.openai.com/v1"

    public struct Configuration {
        public let apiKey: String
        public let baseURL: URL
        public let transport: any ClientTransport

        public static func `default`(apiKey: String) -> Configuration {
            Configuration(
                apiKey: apiKey,
                baseURL: .openAIBaseURL,
                transport: AsyncHTTPClientTransport()
            )
        }

        public init(
            apiKey: String,
            baseURL: URL,
            transport: any ClientTransport
        ) {
            self.apiKey = apiKey
            self.baseURL = baseURL
            self.transport = transport
        }

        public init(apiKey: String) {
            self.init(
                apiKey: apiKey,
                baseURL: .openAIBaseURL,
                transport: AsyncHTTPClientTransport()
            )
        }
    }

    public static func client(with configuration: Configuration) -> APIProtocol {
        let authMiddleware = AuthenticationMiddleware(apiKey: configuration.apiKey)

        return Client(
            serverURL: configuration.baseURL,
            transport: configuration.transport,
            middlewares: [authMiddleware])
    }
}

extension URL {
    package static let openAIBaseURL = URL(string: OpenAI.baseURLString)!
}
