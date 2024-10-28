//
//  DeleteLineItems.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Delete all line items from document from Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document
    ///   - completion: completion description
    public func deleteDocumentLineItems(documentId: String, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .DELETE, route: .documents, queryItem: String(format: "%@/line-items", documentId), completion: completion)
    }
}
