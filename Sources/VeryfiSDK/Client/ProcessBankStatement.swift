//
//  ProcessBankStatement.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Upload  a bank statement for the Veryfi API to process.
    /// https://docs.veryfi.com/api/bank-statements/process-a-bank-statement/
    /// - Parameters:
    ///     - fileName: Name of the file to upload to the Veryfi API.
    ///     - fileData: UTF8 encoded file data
    ///     - confidenceDetails: Confidence details object
    ///     - params: Additional parameters.
    ///     - completion: Function called after request completes.
    ///     -  detail: Response from server.
    ///     -  error: Error from server.
    public func processBankStatement(fileName: String,
                                fileData: Data,
                                params: [String: Any]? = nil,
                                confidenceDetails: Bool = false,
                                withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        var requestParams = params ?? [String: Any]()
        requestParams["confidence_details"] = confidenceDetails
        requestParams["file_data"] = fileData.base64EncodedString()
        requestParams["file_name"] = fileName

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestParams, options: .prettyPrinted) else {
            completion(.failure(.parsingError))
            return
        }

        self.request(method: .POST, route: .bankStatements, uploadData: jsonData, completion: completion)
    }
}
