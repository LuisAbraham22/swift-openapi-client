import Foundation
import HTTPTypes
import OpenAPIRuntime

package struct AuthenticationMiddleware: ClientMiddleware {
    private let apiKey: String

    package init(apiKey: String) {
        self.apiKey = apiKey
    }

    package func intercept(
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
