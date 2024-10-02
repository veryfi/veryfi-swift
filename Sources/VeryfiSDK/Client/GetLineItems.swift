//
//  GetLineItems.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Get all line items from document.
    /// - Parameters:
    ///   - documentId: ID of document to get line items.
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getDocumentLineItems(documentId: String, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .documents, queryItem: String(format: "%@/line-items", documentId), completion: completion)
    }
}
