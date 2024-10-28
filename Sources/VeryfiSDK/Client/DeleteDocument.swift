//
//  DeleteDocument.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Delete document from Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document to delete.
    ///   - completion: completion description
    public func deleteDocument(documentId: String, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .DELETE, route: .documents, queryItem: documentId, completion: completion)
    }
}
