//
//  main.swift
//  SwiftOpenAIClient
//
//  Created by Luis Abraham on 2025-02-01.
//
import Foundation
import HTTPTypes
import OpenAPIRuntime
import SwiftOpenAIClient

let apiKey = "<your api key>"

let client = OpenAI.client(with: .default(apiKey: apiKey))

let response = try await client.createChatCompletion(
    body: .json(
        .init(
            messages: [
                .ChatCompletionRequestUserMessage(
                    .init(
                        content: .case1("Explain to me how LLMs work in a short and succinct way"),
                        role: .user))
            ],
            model: .init(value2: .gpt4oMini),
            stream: false)))

// Access the response content
if case .json(let completion) = try response.ok.body {
    print("Assistant's response: \(completion.choices[0].message.content)")
    print("Model used: \(completion.model)")
    print("Total tokens: \(completion.usage?.totalTokens)")
    print("Prompt tokens: \(completion.usage?.promptTokens)")
    print("Completion tokens: \(completion.usage?.completionTokens)")
}
// typealias ChatGPTPayload = Components.Schemas.CreateChatCompletionStreamResponse

// let chatGPTStream = try response.ok.body.textEventStream
//     .asDecodedServerSentEventsWithJSONData(
//         of: ChatGPTPayload.self,
//         while: {
//             $0 != HTTPBody.ByteChunk("[DONE]".utf8)
//         })

// for try await message in chatGPTStream {
//     print(message.data?.choices[0].delta.content ?? "<nil>", terminator: "")
//     fflush(stdout)
//     // Simulate streaming response
//     try await Task.sleep(for: .seconds(0.1))
// }
