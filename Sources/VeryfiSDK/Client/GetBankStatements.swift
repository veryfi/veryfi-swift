//
//  GetBankStatements.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Get all bank statements from Veryfi inbox.
    /// - Parameters:
    ///   - queryItems: Query items to apply to the get request.
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getBankStatements(queryItems: [URLQueryItem]? = nil, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .bankStatements, queryItems: queryItems, completion: completion)
    }
}
