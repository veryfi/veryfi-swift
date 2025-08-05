//
//  ProcessAnyDocument.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Upload any document for the Veryfi API to process.
    /// https://docs.veryfi.com/api/anydocs/process-a-A-doc/
    /// - Parameters:
    ///     - fileName: Name of the file to upload to the Veryfi API.
    ///     - fileData: UTF8 encoded file data
    ///     - categories: List of document categories.
    ///     - deleteAfterProcessing: Do not store file in Veryfi's inbox.
    ///     - params: Additional parameters.
    ///     - completion: Function called after request completes.
    ///     -  detail: Response from server.
    ///     -  error: Error from server.
    public func processAnyDocument(fileName: String,
                                fileData: Data,
                                params: [String: Any]? = nil,
                                templateName: String,
                                withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        var requestParams = params ?? [String: Any]()
        requestParams["file_data"] = fileData.base64EncodedString()
        requestParams["file_name"] = fileName
        requestParams["template_name"] = templateName

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestParams, options: .prettyPrinted) else {
            completion(.failure(.parsingError))
            return
        }

        self.request(method: .POST, route: .anyDocuments, uploadData: jsonData, completion: completion)
    }
}
