import Foundation
import _Concurrency

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
    /// - Parameters:
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getDocuments(withCompletion completion: @escaping (_ detail: Data?, _ error: Error?) -> Void) {
        let headers = self.getHeaders()
        let apiUrl = "\(self.getUrl())/partner/documents/"
        let url = URL(string: apiUrl)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard error == nil else {
                print("Error: error calling request")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                print(response)
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { //Array of objects?
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                completion(prettyJsonData, nil)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }).resume()
    }
    
    /// Checks for error with response.
    /// - Parameters:
    ///   - data: Data from server.
    ///   - response: Response code from server.
    ///   - error: Error from server.
    /// - Returns: True or false for problems with response.
    private func check_err(data: Data?, response: URLResponse?, error: Error?) -> Bool {
        guard error == nil else {
            print("Error: error calling request")
            print(error!)
            return true
        }
        guard data != nil else {
            print("Error: Did not receive data")
            return true
        }
        guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
            print("Error: HTTP request failed")
            print(response!)
            return true
        }
        return false
    }
    
    
    /// Get single document by ID from Veryfi inbox.
    /// - Parameters:
    ///   - documentId:  ID of document to retreive
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func getDocument(documentId: String) async throws -> [String:Any] {
        let (data,response) = try await self.request(http_verb: "GET", endpointName: "/\(documentId)/", params: ["id":documentId])
        guard (response as! HTTPURLResponse).statusCode == 200 else {throw MyError.runtimeError(response)}
        
        let jsonObject = (try JSONSerialization.jsonObject(with: data) as? [String: Any])!
        return jsonObject
    }
    
    /// Upload an image for the Veryfi API to process.
    ///
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
                                 withCompletion completion: @escaping (_ detail: Data?, _ error: Error?) -> Void) {
        let requestCats = categories ?? self.CATEGORIES
        var optionalParams: [String:Any] = ["categories": requestCats,
                                  "auto_delete": deleteAfterProcessing]
        for (k, v) in params {
            optionalParams.updateValue(v, forKey: k)
        }
        let fileExtend = fileName.components(separatedBy: ".").last! //Add error for need to include file extension
        let mimeType = "image/\(fileExtend)"
        
        let headers: [String:String] = self.getHeaders()
        let apiUrl: String = "\(self.getUrl())/partner/documents/"
        let url: URL = URL(string: apiUrl)!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        var data = Data()
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
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
        
        print(String(decoding:data, as: UTF8.self))
        
        session.uploadTask(with: request, from: data, completionHandler: { data, response, error -> Void in
            if self.check_err(data: data, response: response, error: error) { completion(nil, error) }

            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data!) as? [String: Any] else { //force unwrapping data
                    print("Error: Cannot convert data to JSON object")
                    completion(data,error)
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    completion(data,error)
                    return
                }
                
                completion(prettyJsonData, nil)
            } catch {
                print("Error: Trying to convert JSON data to string")
                completion(data,error)
                return
            }
        }).resume()
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
                                   categories: [String]? = nil, //Fix categories default
                                   deleteAfterProcessing: Bool = false,
                                   boostMode: Int = 0,
                                   externalId: String? = nil,
                                   maxPagesToProcess: Int? = 1,
                                   withCompletion completion: @escaping (_ detail: Data?, _ error: Error?) -> Void) {
        let headers: [String:String] = self.getHeaders()
        let apiUrl: String = "\(self.getUrl())/partner/documents/"
        let url: URL = URL(string: apiUrl)!
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        let params: [String: Any] = ["auto_delete": deleteAfterProcessing,
                            "boost_mode": boostMode,
                            "categories": categories,
                            "external_id": externalId as Any, //implicit coerce
                            "file_url": fileUrl as Any, //implicit coerce
                            "file_urls": fileUrls as Any, //implicit coerce
                            "max_pages_to_process": maxPagesToProcess as Any] //implicit coerce
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData
        session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if self.check_err(data: data, response: response, error: error) { completion(nil, error) }

            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data!) as? [String: Any] else { //force unwrapping data
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                
                completion(prettyJsonData, nil)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }).resume()
    }
    
    
    /// Update information of document in Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document to modify.
    ///   - params: Names and values to modify.
    ///   - completion: A block to execute
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func updateDocument(documentId: String, params: [String: Any]) async throws -> [String:Any] {
        let (data,response) = try await self.request(http_verb: "PUT", endpointName: "/\(documentId)/", params: params)
        guard (response as! HTTPURLResponse).statusCode == 200 else {throw MyError.runtimeError(response)}
        
        let jsonObject = (try JSONSerialization.jsonObject(with: data) as? [String: Any])!
        return jsonObject
    }
    
    
    /// Delete document from Veryfi inbox.
    /// - Parameters:
    ///   - documentId: ID of document to delete.
    /// - Returns: JSON object of data
    public func deleteDocument(documentId: String) async throws -> [String:Any] {
        let (data,response) = try await self.request(http_verb: "DELETE", endpointName: "/\(documentId)/", params: ["id":documentId])
        guard (response as! HTTPURLResponse).statusCode == 200 else {throw MyError.runtimeError(response)}
        
        let jsonObject = (try JSONSerialization.jsonObject(with: data) as? [String: Any])!
        return jsonObject
    }
    
    /// Make generic async request to server
    /// - Parameters:
    ///   - http_verb: GET, POST, PUT, DELETE
    ///   - endpointName: Endpoint specified in API
    ///   - params: Request params
    /// - Returns: Object of data
    private func request(http_verb: String, endpointName: String, params: [String:Any]) async throws -> (Data,URLResponse) {
        let headers: [String:String] = self.getHeaders()
        let apiUrl: String = "\(self.getUrl())/partner/documents\(endpointName)"
        let url: URL = URL(string: apiUrl)!
        /*
        if self.client_secret != "" {
            let timestamp = NSDate().timeIntervalSince1970
            let myTimeInterval = TimeInterval(timestamp)
            let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
//            let signature = self._generate_signature(request_arguments, timestamp=timestamp)
            headers["X-Veryfi-Request-Timestamp"] = String(format: "%f", time)
//            headers["X-Veryfi-Request-Signature"] = signature
        }
        */
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = http_verb
        request.allHTTPHeaderFields = headers
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData
        
        let (data, response) = try await session.data(for: request)
        guard (response as? HTTPURLResponse)!.statusCode == 200 else {throw MyError.runtimeError(response)}
        return (data,response)
    }
    
    enum MyError: Error { //Generic error to throw
        case runtimeError(URLResponse)
    }
}



/*
//    /**
//     Generate unique signature for payload params.
//     :param payload_params: JSON params to be sent to API request
//     :param timestamp: Unix Long timestamp
//     :return: Unique signature generated using the client_secret and the payload
//     */
//    private func _generate_signature(payload_params: Dictionary<String,Any>, timestamp: String) -> String{
//        var payload = "timestamp:\(timestamp)"
//        for key in payload_params.keys{
//            let value = payload_params[key]
//            payload = "\(payload),\(key):\(value)"
//        }
//
//        let secret_bytes = String(UTF8String: self.client_secret.cStringUsingEncoding(NSUTF8StringEncoding))
//        let payload_bytes = String(UTF8String: payload.cStringUsingEncoding(NSUTF8StringEncoding))
//        let tmp_signature = hmac.new(secret_bytes, msg=payload_bytes, digestmod=hashlib.sha256).digest()
//        let base64_signature = base64.b64encode(tmp_signature).decode("utf-8").strip()
//        return base64_signature
//    }

//    /*
//     Submit the HTTP request.
//     :param http_verb: HTTP Method
//     :param endpoint_name: Endpoint name such as 'documents', 'users', etc.
//     :param request_arguments: JSON payload to send to Veryfi
//     :return: A JSON of the response data.
//     */
 
//
//    /**
//     Get list of documents
//     :return: List of previously processed documents
//     */
//    public func get_documents() -> [String:Any] {
//        let endpoint_name = "/documents/"
//        let request_arguments: [String:String] = [:]
//        let documents = self._request(http_verb: "GET", endpoint_name: endpoint_name, request_arguments: request_arguments)
//        if "documents" in documents{
//                return documents["documents"]
//        }
//        return documents
//    }
*/
