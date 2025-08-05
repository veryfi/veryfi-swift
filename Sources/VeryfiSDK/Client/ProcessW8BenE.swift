//
//  ProcessW8BenE.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Upload a w8BenE image for the Veryfi API to process.
    /// https://docs.veryfi.com/api/w-8ben-e/process-a-w-8-ben-e/
    /// - Parameters:
    ///     - fileName: Name of the file to upload to the Veryfi API.
    ///     - fileData: UTF8 encoded file data
    ///     - params: Additional parameters.
    ///     - completion: Function called after request completes.
    ///     -  detail: Response from server.
    ///     -  error: Error from server.
    public func processW8BenE(fileName: String,
                                fileData: Data,
                                params: [String: Any]? = nil,
                                withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        var requestParams = params ?? [String: Any]()
        requestParams["file_data"] = fileData.base64EncodedString()
        requestParams["file_name"] = fileName

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestParams, options: .prettyPrinted) else {
            completion(.failure(.parsingError))
            return
        }

        self.request(method: .POST, route: .w8BenE, uploadData: jsonData, completion: completion)
    }
}
