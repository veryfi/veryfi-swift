//
//  AddLineItem.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Create line item for document in Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document to modify.
    ///   - params: Line item data.
    ///   - completion: A block to execute
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func addLineItem(documentId: String, params: AddLineItem, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: params.dictionary)
        self.request(method: .POST, route: .documents, body: jsonData, queryItem: String(format: "%@/line-items", documentId), completion: completion)
    }
}
