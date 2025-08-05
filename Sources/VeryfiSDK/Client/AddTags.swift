//
//  AddTags.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Add multiple tags in document.
    /// https://docs.veryfi.com/api/receipts-invoices/add-tags-to-a-document/ 
    /// - Parameters:
    ///   - documentId: ID of document to replace tags.
    ///   - params: Tags data.
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func addTags(documentId: String, params: AddTags, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: params.dictionary)
        self.request(method: .POST, route: .documents, body: jsonData, queryItem: String(format: "%@/tags", documentId), completion: completion)
    }
}
