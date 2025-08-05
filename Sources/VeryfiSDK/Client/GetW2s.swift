//
//  GetW2s.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Get all w2 documents from Veryfi inbox.
    /// https://docs.veryfi.com/api/w2s/get-w-2-s/
    /// - Parameters:
    ///   - queryItems: Query items to apply to the get request.
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getW2s(queryItems: [URLQueryItem]? = nil, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .w2s, queryItems: queryItems, completion: completion)
    }
}
