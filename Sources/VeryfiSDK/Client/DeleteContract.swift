//
//  DeleteContract.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Delete contract from Veryfi inbox.
    /// https://docs.veryfi.com/api/contracts/delete-a-contract/
    /// - Parameters:
    ///   - contractId: ID of contract to delete.
    ///   - completion: completion description
    public func deleteContract(contractId: Int, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .DELETE, route: .contracts, queryItem: String(contractId), completion: completion)
    }
} 