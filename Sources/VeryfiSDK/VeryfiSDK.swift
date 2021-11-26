import Foundation
import FoundationNetworking


struct VeryfiCredentials {
    let clientId: String
    let clientSecret: String
    let username: String
    let apiKey: String
}

class Client: NetworkManager {
    
    /// Init Client.
    /// - Parameters:
    ///   - clientId: Your client id from veryfi-hub.
    ///   - clientSecret: Your client secret from veryfi-hub.
    ///   - username: Your username from veryfi-hub.
    ///   - apiKey: Your api key from veryfi-hub.
    ///   - apiVersion: Api version to use, by default "v8".
    init(clientId: String, clientSecret: String, username: String, apiKey: String, apiVersion: String = "v8") {
        let credentials = VeryfiCredentials(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey)
        super.init(credentials: credentials, apiVersion: apiVersion)
    }
    
    /// Get all documents from Veryfi inbox.
    /// - Parameters:
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getDocuments(withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .documents, completion: completion)
    }
    
    /// Get single document by ID from Veryfi inbox.
    /// - Parameters:
    ///   - documentId:  ID of document to retreive
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getDocument(documentId: String, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .GET, route: .documents, queryItem: documentId, completion: completion)
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
                                params: [String: Any]? = nil,
                                withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let requestCats = categories ?? []
        var requestParams = params ?? [String: Any]()
        requestParams["categories"] = requestCats
        requestParams["auto_delete"] = deleteAfterProcessing
        requestParams["file_data"] = fileData.base64EncodedString()
        requestParams["file_name"] = fileName
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestParams, options: .prettyPrinted) else {
            completion(.failure(.parsingError))
            return
        }
        
        self.request(method: .POST, route: .documents, uploadData: jsonData, completion: completion)
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
        self.request(method: .POST, route: .documents, body: jsonData, completion: completion)
    }
    
    /// Update information of document in Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document to modify.
    ///   - params: Names and values to modify.
    ///   - completion: A block to execute
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func updateDocument(documentId: String, params: [String: Any], withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        self.request(method: .PUT, route: .documents, body: jsonData, queryItem: documentId, completion: completion)
    }

    /// Delete document from Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document to delete.
    ///   - completion: completion description
    public func deleteDocument(documentId: String, withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        self.request(method: .DELETE, route: .documents, queryItem: documentId, completion: completion)
    }
}
