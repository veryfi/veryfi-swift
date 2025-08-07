//
//  ProcessContract.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Upload a contract for the Veryfi API to process.
    /// https://docs.veryfi.com/api/contracts/process-a-contract/
    /// - Parameters:
    ///     - fileName: Name of the file to upload to the Veryfi API.
    ///     - fileData: UTF8 encoded file data
    ///     - deleteAfterProcessing: Do not store file in Veryfi's inbox.
    ///     - maxPagesToProcess: Limit processing to number of pages (1-50, default 50).
    ///     - params: Additional parameters.
    ///     - completion: Function called after request completes.
    ///     -  detail: Response from server.
    ///     -  error: Error from server.
    public func processContract(fileName: String,
                               fileData: Data,
                               deleteAfterProcessing: Bool = false,
                               maxPagesToProcess: Int = 50,
                               params: [String: Any]? = nil,
                               withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        var requestParams = params ?? [String: Any]()
        requestParams["auto_delete"] = deleteAfterProcessing
        requestParams["max_pages_to_process"] = maxPagesToProcess
        requestParams["file_data"] = fileData.base64EncodedString()
        requestParams["file_name"] = fileName

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestParams, options: .prettyPrinted) else {
            completion(.failure(.parsingError))
            return
        }

        self.request(method: .POST, route: .contracts, uploadData: jsonData, completion: completion)
    }
} 