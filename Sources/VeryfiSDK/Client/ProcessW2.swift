//
//  ProcessW2.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Upload a w2 image for the Veryfi API to process.
    /// - Parameters:
    ///     - fileName: Name of the file to upload to the Veryfi API.
    ///     - fileData: UTF8 encoded file data
    ///     - categories: List of document categories.
    ///     - deleteAfterProcessing: Do not store file in Veryfi's inbox.
    ///     - params: Additional parameters.
    ///     - completion: Function called after request completes.
    ///     -  detail: Response from server.
    ///     -  error: Error from server.
    public func processW2(fileName: String,
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

        self.request(method: .POST, route: .w2s, uploadData: jsonData, completion: completion)
    }
}
