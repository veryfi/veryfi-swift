//
//  DeleteCheck.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Delete a check by ID.
    /// https://docs.veryfi.com/api/checks/delete-a-check/
    /// - Parameters:
    ///   - checkId: The ID of the check to delete.
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func deleteCheck(checkId: Int, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .DELETE, route: .checks, queryItem: String(checkId), completion: completion)
    }
} 
