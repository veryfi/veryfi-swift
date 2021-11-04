//
//  VeryfiSDK.swift
//
//
//  Created by Diego Giraldo Gómez on 3/11/21.
//

import Foundation

struct VeryfiCredentials {
    let clientId : String
    let clientSecret : String
    let username : String
    let apiKey : String
}

public struct VeryfiSDK {
    let credentials: VeryfiCredentials
    
    /// Get all documents from Veryfi inbox.
    /// - Parameters:
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getDocuments(withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let manager = NetworkManager(credentials: credentials)
        manager.request(method: .GET, route: .documents, completion: completion)
    }
    
    /// Get single document by ID from Veryfi inbox.
    /// - Parameters:
    ///   - documentId:  ID of document to retreive
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getDocument(documentId: String, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let manager = NetworkManager(credentials: credentials)
        manager.request(method: .GET, route: .documents, queryItem: documentId, completion: completion)
    }
    
    /// Upload an image for the Veryfi API to process.
    /// - Parameters:
    ///     - fileName: Name of the file to upload to the Veryfi API.
    ///     - fileData: UTF8 encoded file data
    ///     - categories: List of document categories.
    ///     - deleteAfterProcessing: Do not store file in Veryfi's inbox.
    ///     - params: Additional parameters.
    ///     - completion: Function called after request completes.
    ///     -  detail: Response from server.
    ///     -  error: Error from server.
    public func processDocument(fileName: String,
                                fileData: Data,
                                 categories: [String]? = nil,
                                 deleteAfterProcessing: Bool = false,
                                 params: [String: Any] = [:],
                                 withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let requestCats = categories ?? []
        var optionalParams: [String:Any] = ["categories": requestCats,
                                            "auto_delete": deleteAfterProcessing]
        for (k, v) in params {
            optionalParams.updateValue(v, forKey: k)
        }
        guard let fileExtend = fileName.components(separatedBy: ".").last else {
            completion(.failure(.internalError))
            return
        }
        
        let mimeType = "image/\(fileExtend)"
        
        var data = Data()
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        data.append(fileData)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file_name\"\r\n".data(using: .utf8)!)
        data.append("\r\n\"\(fileName)\"".data(using: .utf8)!)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        
        for (key,value) in optionalParams {
            data.append("Content-Disposition: form-data; name=\"\(key)\";\r\n".data(using: .utf8)!)
            data.append("\"\(value)\"".data(using: .utf8)!)
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        }
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let manager = NetworkManager(credentials: credentials)
        manager.request(method: .POST, route: .documents, uploadData: data, completion: completion)
    }
    
    /// Upload document to Veryfi API with URL.
    /// - Parameters:
    ///   - fileUrl: Publicly available URL.
    ///   - fileUrls: List of publicly available URLs.
    ///   - categories: List of document categories.
    ///   - deleteAfterProcessing: Do not store file in Veryfi's inbox.
    ///   - boostMode: Skip data enrichment but process document faster.
    ///   - externalId: Existing ID to assign to document.
    ///   - maxPagesToProcess: Number of pages to process.
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func processDocumentURL(fileUrl: String? = nil,
                                   fileUrls: [String]? = nil,
                                   categories: [String]? = nil,
                                   deleteAfterProcessing: Bool = false,
                                   boostMode: Int = 0,
                                   externalId: String? = nil,
                                   maxPagesToProcess: Int? = 1,
                                   withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let params: [String: Any] = ["auto_delete": deleteAfterProcessing,
                                     "boost_mode": boostMode,
                                     "categories": categories ?? [],
                                     "external_id": externalId as Any, //implicit coerce
                                     "file_url": fileUrl as Any, //implicit coerce
                                     "file_urls": fileUrls as Any, //implicit coerce
                                     "max_pages_to_process": maxPagesToProcess as Any] //implicit coerce
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        let manager = NetworkManager(credentials: credentials)
        manager.request(method: .POST, route: .documents, body: jsonData, completion: completion)
    }
    
    /// Update information of document in Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document to modify.
    ///   - params: Names and values to modify.
    ///   - completion: A block to execute
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func updateDocument(documentId: String, params: [String: Any], withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let manager = NetworkManager(credentials: credentials)
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        manager.request(method: .PUT, route: .documents, body: jsonData, queryItem: documentId, completion: completion)
    }

    /// Delete document from Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document to delete.
    ///   - completion: completion description
    public func deleteDocument(documentId: String, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let manager = NetworkManager(credentials: credentials)
        manager.request(method: .DELETE, route: .documents, queryItems: [URLQueryItem(name: "id", value: documentId)], completion: completion)
    }
}
