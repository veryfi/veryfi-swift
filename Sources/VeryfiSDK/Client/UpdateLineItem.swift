//
//  UpdateLineItem.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Update line item for document in Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document.
    ///   - lineItemId: ID of line item to modify.
    ///   - params: Line item data.
    ///   - completion: A block to execute
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func updateLineItem(documentId: String, lineItemId: String, params: UpdateLineItem, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: params.dictionary)
        self.request(method: .PUT, route: .documents, body: jsonData, queryItem: String(format: "%@/line-items/%@", documentId, lineItemId), completion: completion)
    }
}
