//
//  GetContract.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Get a specific contract from Veryfi inbox.
    /// https://docs.veryfi.com/api/contracts/get-a-contract/
    /// - Parameters:
    ///   - contractId: ID of contract to retrieve.
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getContract(contractId: Int, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .contracts, queryItem: String(contractId), completion: completion)
    }
} 
