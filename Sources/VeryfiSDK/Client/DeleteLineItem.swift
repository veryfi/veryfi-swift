//
//  DeleteLineItem.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Delete  line item from document from Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document
    ///   - lineItemId: ID of line item to delete.
    ///   - completion: completion description
    public func deleteLineItem(documentId: String, lineItemId: String, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .DELETE, route: .documents, queryItem: String(format: "%@/line-items/%@", documentId, lineItemId), completion: completion)
    }
}
