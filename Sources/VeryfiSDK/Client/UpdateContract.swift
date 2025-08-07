//
//  UpdateContract.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Update information of contract in Veryfi inbox.
    /// https://docs.veryfi.com/api/contracts/update-a-contract/
    /// - Parameters:
    ///   - contractId: ID of contract to modify.
    ///   - params: Names and values to modify.
    ///   - completion: A block to execute
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func updateContract(contractId: Int, params: [String: Any], withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        self.request(method: .PUT, route: .contracts, body: jsonData, queryItem: String(contractId), completion: completion)
    }
} 