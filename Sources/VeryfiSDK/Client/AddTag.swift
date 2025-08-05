//
//  AddTag.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Add tag to document.
    /// https://docs.veryfi.com/api/receipts-invoices/add-a-tag-to-a-document/
    /// - Parameters:
    ///   - documentId: ID of document to add tag.
    ///   - params: Tag data.
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func addTag(documentId: String, params: AddTag, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: params.dictionary)
        self.request(method: .PUT, route: .documents, body: jsonData, queryItem: String(format: "%@/tags", documentId), completion: completion)
    }
}
