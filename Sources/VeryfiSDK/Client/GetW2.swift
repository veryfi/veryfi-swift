//
//  GetW2.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Get single w2 document by ID from Veryfi inbox.
    /// https://docs.veryfi.com/api/w2s/get-a-w-2/
    /// - Parameters:
    ///   - documentId:  ID of document to retreive
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getW2(documentId: String, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .w2s, queryItem: documentId, completion: completion)
    }
}
