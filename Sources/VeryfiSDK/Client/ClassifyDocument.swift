//
//  ClassifyDocument.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Classify a document and extract all the fields from it.
    /// - Parameters:
    ///   - fileName: Name of the file to upload to the Veryfi API.
    ///   - fileData: UTF8 encoded file data
    ///   - params: Additional parameters.
    ///   - completion: Function called after request completes.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func classifyDocument(fileName: String,
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

        self.request(method: .POST, route: .classify, uploadData: jsonData, completion: completion)
    }
    
    /// Classify a document from URL and extract all the fields from it.
    /// - Parameters:
    ///   - fileUrl: Publicly available URL.
    ///   - fileUrls: List of publicly available URLs.
    ///   - params: Additional parameters.
    ///   - completion: Function called after request completes.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func classifyDocumentURL(fileUrl: String? = nil,
                                   fileUrls: [String]? = nil,
                                   params: [String: Any]? = nil,
                                   withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        var requestParams = params ?? [String: Any]()
        requestParams["file_url"] = fileUrl as Any
        requestParams["file_urls"] = fileUrls as Any

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestParams, options: .prettyPrinted) else {
            completion(.failure(.parsingError))
            return
        }

        self.request(method: .POST, route: .classify, body: jsonData, completion: completion)
    }
} 