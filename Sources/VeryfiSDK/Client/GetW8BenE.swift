//
//  GetW8BenE.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Get single w8BenE document by ID from Veryfi inbox.
    /// https://docs.veryfi.com/api/w-8ben-e/get-a-w-8-ben-e/
    /// - Parameters:
    ///   - documentId:  ID of document to retreive
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getW8BenE(documentId: String, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .w8BenE, queryItem: documentId, completion: completion)
    }
}
