//
//  GetCheck.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Get a specific check by ID.
    /// - Parameters:
    ///   - checkId: The ID of the check to retrieve.
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getCheck(checkId: Int, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .checks, queryItem: String(checkId), completion: completion)
    }
} 