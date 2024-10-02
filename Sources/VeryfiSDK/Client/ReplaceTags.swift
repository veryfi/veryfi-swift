//
//  ReplaceTags.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Replace tags in document.
    /// - Parameters:
    ///   - documentId: ID of document to add tag.
    ///   - params: New tags to replace.
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func replaceTags(documentId: String, params: [String], withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: ["tags": params])
        self.request(method: .PUT, route: .documents, body: jsonData, queryItem: documentId, completion: completion)
    }
}
