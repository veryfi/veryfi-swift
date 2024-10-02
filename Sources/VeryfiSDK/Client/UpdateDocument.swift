//
//  UpdateDocument.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Update information of document in Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document to modify.
    ///   - params: Names and values to modify.
    ///   - completion: A block to execute
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func updateDocument(documentId: String, params: [String: Any], withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        self.request(method: .PUT, route: .documents, body: jsonData, queryItem: documentId, completion: completion)
    }
}
