//
//  GetBankStatement.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Get single bank statements by ID from Veryfi inbox.
    /// https://docs.veryfi.com/api/bank-statements/get-a-bank-statement/
    /// - Parameters:
    ///   - documentId:  ID of document to retreive
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getBankStatement(id: String, queryItems: [URLQueryItem]? = nil, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .bankStatements, queryItems: queryItems, queryItem: id, completion: completion)
    }
}
