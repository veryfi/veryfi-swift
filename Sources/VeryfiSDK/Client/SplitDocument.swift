//
//  SplitDocument.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Split a document into multiple documents.
    /// - Parameters:
    ///   - fileName: Name of the file to upload to the Veryfi API.
    ///   - fileData: UTF8 encoded file data
    ///   - params: Additional parameters.
    ///   - completion: Function called after request completes.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func splitDocument(fileName: String,
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

        self.request(method: .POST, route: .split, uploadData: jsonData, completion: completion)
    }
    
    /// Split a document from URL into multiple documents.
    /// - Parameters:
    ///   - fileUrl: Publicly available URL.
    ///   - fileUrls: List of publicly available URLs.
    ///   - params: Additional parameters.
    ///   - completion: Function called after request completes.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func splitDocumentURL(fileUrl: String? = nil,
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

        self.request(method: .POST, route: .split, body: jsonData, completion: completion)
    }
    
    /// Get a specific split document by ID.
    /// - Parameters:
    ///   - splitId: The ID of the split document to retrieve.
    ///   - completion: Function called after request completes.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getSplitDocument(splitId: Int,
                                withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .split, queryItem: String(splitId), completion: completion)
    }
    
    /// Get all split documents.
    /// - Parameters:
    ///   - completion: Function called after request completes.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getSplitDocuments(withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .split, completion: completion)
    }
} 
