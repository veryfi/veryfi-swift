//
//  GetLineItem.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Get single line item by document from Veryfi inbox.
    /// - Parameters:
    ///   - documentId:  ID of document.
    ///   - lineItemId:  ID of line item.
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getLineItem(documentId: String, lineItemId: String, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .documents, queryItem: String(format: "%@/line-items/%@", documentId, lineItemId), completion: completion)
    }
}
