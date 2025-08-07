//
//  GetContracts.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Get all contracts from Veryfi inbox.
    /// https://docs.veryfi.com/api/contracts/get-contracts/
    /// - Parameters:
    ///   - queryItems: Query items to apply to the get request (e.g., page, page_size).
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getContracts(queryItems: [URLQueryItem]? = nil, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .contracts, queryItems: queryItems, completion: completion)
    }
} 