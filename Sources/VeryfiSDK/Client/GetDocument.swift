//
//  GetDocument.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Get single document by ID from Veryfi inbox.
    /// - Parameters:
    ///   - documentId:  ID of document to retreive
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getDocument(documentId: String, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .documents, queryItem: documentId, completion: completion)
    }
}
