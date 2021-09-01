import Foundation
import _Concurrency
import CryptoKit
@available(macOS 12.0.0, *)
public class Client {
    
    let clientId : String
    let clientSecret : String
    let username : String
    let apiKey : String
    let baseUrl = "https://api.veryfi.com/api/"
    let apiVersion = "v7"
    let timeout = 120
    var headers : [String:String]
    let session = URLSession.shared
    let CATEGORIES: [String]
    
    /// Create a Client object to communicate with the Veryfi API
    ///
    /// Parameters can be found at Veryfi Hub -> Settings -> Keys
    /// - Parameters:
    ///   - clientId: Veryfi client ID
    ///   - clientSecret: Veryfi client secret
    ///   - username:Veryfi username
    ///   - apiKey: Veryfi API key
    public init(clientId : String,
                clientSecret : String,
                username : String,
                apiKey : String
    ) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.username = username
        self.apiKey = apiKey
        self.headers = [:]
        self.CATEGORIES = [
            "Advertising & Marketing",
            "Automotive",
            "Bank Charges & Fees",
            "Legal & Professional Services",
            "Insurance",
            "Meals & Entertainment",
            "Office Supplies & Software",
            "Taxes & Licenses",
            "Travel",
            "Rent & Lease",
            "Repairs & Maintenance",
            "Payroll",
            "Utilities",
            "Job Supplies",
            "Grocery",
        ]
    }
    
    /// Prepares headers needed for request.
    /// - Returns: Dictionary with headers.
    private func getHeaders() -> [String:String] {
        let headers = [
            "User-Agent": "Python Veryfi-Swift/0.0.1",
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Client-Id": self.clientId,
            "Authorization": "apikey \(self.username):\(self.apiKey)"
        ]
        return headers
    }
    
    /// Get URL for requests.
    /// - Returns: Base URL with API version.
    private func getUrl() -> String {
        return self.baseUrl + self.apiVersion
    }
    
    /// Get all documents from Veryfi inbox.
    /// - Returns: Data and response containing all files from Veryfi inbox.
    public func getDocuments() async throws -> (Data,URLResponse) {
        let (data,response) = try await self.request(http_verb: "GET", endpointName: "/", params: [:])
        
        return (data,response)
    }
    
    
    /// Get single document by ID from Veryfi inbox.
    /// - Parameters:
    ///   - documentId:  ID of document to retreive
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getDocument(documentId: String) async throws -> (Data,URLResponse) {
        do {
            let (data,response) = try await self.request(http_verb: "GET", endpointName: "/\(documentId)/", params: ["id":documentId])
            return (data,response)
        } catch {
            throw error
        }
    }
    
    /// Upload an image for the Veryfi API to process.
    /// - Parameters:
    ///     - fileName: Name of the file to upload to the Veryfi API.
    ///     - fileData: UTF8 encoded file data
    ///     - categories: List of document categories.
    ///     - deleteAfterProcessing: Do not store file in Veryfi's inbox.
    ///     - params: Additional parameters.
    /// - Returns: Data object of JSON items and server response
    public func processDocument(fileName: String,
                                fileData: Data,
                                 categories: [String]? = nil,
                                 deleteAfterProcessing: Bool = false,
                                 params: [String: Any] = [:]) async throws -> (Data,URLResponse) {
        let requestCats = categories ?? self.CATEGORIES
        var currParams: [String:Any] = ["categories": requestCats,
                                  "auto_delete": deleteAfterProcessing]
        for (k, v) in params {
            currParams.updateValue(v, forKey: k)
        }
        let fileExtend = fileName.components(separatedBy: ".").last! //Add error for need to include file extension
        let mimeType = "image/\(fileExtend)"
        
        let headers: [String:String] = self.getHeaders()
        let apiUrl: String = "\(self.getUrl())/partner/documents/"
        let url: URL = URL(string: apiUrl)!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        var body = Data()
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"file_name\"\r\n".data(using: .utf8)!)
        body.append("\r\n\"\(fileName)\"".data(using: .utf8)!)
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        
        for (key,value) in currParams {
            body.append("Content-Disposition: form-data; name=\"\(key)\";\r\n".data(using: .utf8)!)
            body.append("\"\(value)\"".data(using: .utf8)!)
            body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        }
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let (data,response) = try await session.upload(for: request, from: body)
        guard (response as? HTTPURLResponse)!.statusCode < 300 else {
            throw VeryfiError.runtimeError((response as! HTTPURLResponse).statusCode, try convertToJson(resData: data))
        }
        return (data,response)
    }
    
    /// Upload document to Veryfi API with URL.
    /// - Parameters:
    ///   - fileUrl: Publicly available URL.
    ///   - fileUrls: List of publicly available URLs.
    ///   - categories: List of document categories.
    ///   - deleteAfterProcessing: Do not store file in Veryfi's inbox.
    ///   - params: Additional parameters
    /// - Returns: Data object of JSON items and server response
    public func processDocumentURL(fileUrl: String? = nil,
                                   fileUrls: [String]? = nil,
                                   categories: [String]? = nil, //Fix categories default
                                   deleteAfterProcessing: Bool = false,
                                   params: [String: Any] = [:]) async throws -> (Data,URLResponse) {
        let requestCats = categories ?? self.CATEGORIES
        var currParams: [String: Any] = ["auto_delete": deleteAfterProcessing,
                            "categories": requestCats,
                            "file_url": fileUrl ?? "", //implicit coerce
                            "file_urls": fileUrls ?? ""] //implicit coerce
        for (k, v) in params {
            currParams.updateValue(v, forKey: k)
        }
        
        do {
            let (data,response) = try await request(http_verb: "POST", endpointName: "/", params: params)
            return (data,response)
        } catch {
            throw error
        }
    }
    
    
    /// Update information of document in Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document to modify.
    ///   - params: Names and values to modify.
    /// - Returns: Data object of JSON items and server response
    public func updateDocument(documentId: String, params: [String: Any]) async throws -> (Data,URLResponse) {
        do {
            let (data,response) = try await self.request(http_verb: "PUT", endpointName: "/\(documentId)/", params: params)
            return (data,response)
        } catch {
            throw error
        }
    }
    
    
    /// Delete document from Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document to delete.
    /// - Returns: Data object of JSON items and server response
    public func deleteDocument(documentId: String) async throws -> (Data,URLResponse) {
        do {
            let (data,response) = try await self.request(http_verb: "DELETE", endpointName: "/\(documentId)/", params: ["id":documentId])
            return (data,response)
        } catch {
            throw error
        }
    }
    
    
    /// Make generic async request to server.
    /// - Parameters:
    ///   - http_verb: HTTP method.
    ///   - endpointName: Endpoint specified in API.
    ///   - params: Request params.
    /// - Returns: Data object of JSON items and server response
    private func request(http_verb: String, endpointName: String, params: [String:Any]) async throws -> (Data,URLResponse) {
        let headers: [String:String] = self.getHeaders()
        let apiUrl: String = "\(self.getUrl())/partner/documents\(endpointName)"
        
//        if self.client_secret != "" {
//            let timestamp = NSDate().timeIntervalSince1970
//            let myTimeInterval = TimeInterval(timestamp)
//            let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
////            let signature = self._generate_signature(request_arguments, timestamp=timestamp)
//            headers["X-Veryfi-Request-Timestamp"] = String(format: "%f", time)
////            headers["X-Veryfi-Request-Signature"] = signature
//        }
        
        var components: URLComponents = URLComponents(string: apiUrl)!
        
        var request: URLRequest = URLRequest(url: components.url!)
        request.httpMethod = http_verb
        request.allHTTPHeaderFields = headers
        
        components.queryItems = []
        if (http_verb == "PUT" || http_verb == "POST") { //More eloquent way to do this
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } else {
            for (k,v) in params {
                components.queryItems!.append(URLQueryItem(name: k, value: "\(v)"))
            }
        }

        let (data, response) = try await session.data(for: request)
        guard (response as! HTTPURLResponse).statusCode < 300 else {
            throw VeryfiError.runtimeError((response as! HTTPURLResponse).statusCode,(try convertToJson(resData: data))["message"]!)
            
        }
        return (data,response)
    }
    
    private func convertToJson(resData: Data) throws -> [String:Any] {
        guard let res = try JSONSerialization.jsonObject(with: resData) as? [String: Any] else {
            throw VeryfiError.jsonError("Error: Could not convert response to object")
        }
        return res
    }
    
    enum VeryfiError: Error {
        case runtimeError(Int,Any)
        case jsonError(String)
        
        public var errorDescription: String? {
                switch self {
                case .runtimeError(let statusCode,let message):
                    return NSLocalizedString("Status Code \(statusCode)", comment: "\(message)")
                case .jsonError:
                    return NSLocalizedString("Could not convert data to JSON", comment: "")
                }
            }
    }
    
    /**
     Generate unique signature for payload params.
     :param payload_params: JSON params to be sent to API request
     :param timestamp: Unix Long timestamp
     :return: Unique signature generated using the client_secret and the payload
     */
//    private func _generate_signature(payload_params: [String:Any], timestamp: String) -> String{
//        var payload = "timestamp:\(timestamp)"
//        for key in payload_params.keys{
//            let value = payload_params[key]
//            payload = "\(payload),\(key):\(value)"
//        }
//
//        let secretBytes = self.clientSecret.data(using: String.Encoding.utf8)
//        let payloadBytes = "\(payload)".data(using: String.Encoding.utf8)
//        let tmp_signature = hmac.new(secretBytes, msg=payloadBytes, digestmod=hashlib.sha256).digest()
//        let base64_signature = base64.b64encode(tmp_signature).decode("utf-8").strip()
//        return base64_signature
//    }
}

