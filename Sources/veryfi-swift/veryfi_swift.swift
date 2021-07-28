import Foundation

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
    
    /**
     Prepares the headers needed for a request.
     :param has_files: Are there any files to be submitted as binary
     :return: Dictionary with headers
     */
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
    
    /**
     Get API Base URL with API Version
     :return: Base URL to Veryfi API
     */
    private func getUrl() -> String {
        return self.baseUrl + self.apiVersion
    }
    
    /*
     Submit the GET request to get all documents.
     :param http_verb: HTTP Method
     :param endpoint_name: Endpoint name such as 'documents', 'users', etc.
     :param request_arguments: JSON payload to send to Veryfi
     :return: A JSON of the response data.
     */
    public func getDocuments(withCompletion completion: @escaping (Data?, Error?) -> Void) {
        //(http_verb: String, endpoint_name: String, request_arguments: [String:String]){
        
        let headers = self.getHeaders()
        let apiUrl = "\(self.getUrl())/partner/documents/"
        let url = URL(string: apiUrl)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        //        request.httpBody = ["":]
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
    
    
    /**
     Request to get a single document by ID
     */
    public func getDocument(documentId: String, withCompletion completion: @escaping (Data?, Error?) -> Void) {
        let headers: [String:String] = self.getHeaders()
        let apiUrl: String = "\(self.getUrl())/partner/documents/\(documentId)/"
        var components: URLComponents = URLComponents(string: apiUrl)!
        components.queryItems = [URLQueryItem(name: "id", value: documentId)]
        
        var request: URLRequest = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if self.check_err(data: data, response: response, error: error) { return }
            
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data!) as? [String: Any] else { //force unwrapping data
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                
                completion(prettyJsonData, nil)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }).resume()
    }
    
    /**
     Get a file from iOS
     */
    private func getFile(fileName: String) -> [UInt8]? {
        // See if the file exists.
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                // Get the raw data from the file.
                let rawData: Data = try Data(contentsOf: fileURL)
                // Return the raw data as an array of bytes.
                return [UInt8](rawData)
            } catch {
                // Couldn't read the file.
                return nil
            }
        }
        print("\(fileName) not exist")
        return nil
    }
    
    
    /**
     Upload a file from iOS
     */
    public func processDocument(fileName: String,
                                 categories: [String] = [], //Fix categories default
                                 deleteAfterProcessing: Bool = false,
                                 withCompletion completion: @escaping (Data?, Error?) -> Void) {
        let headers: [String:String] = self.getHeaders()
        let apiUrl: String = "\(self.getUrl())/partner/documents/"
        let url: URL = URL(string: apiUrl)!
        
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        
        var data = Data()
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        let fileExtension = fileName.components(separatedBy: ".").last! //Throw error if incorrect file name
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Add the file data to the raw http request data
        //    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        //    data.append("Content-Disposition: form-data; name=\"name\"; username=\"kemal\"\r\n".data(using: .utf8)!)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"recieved\(fileExtension)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \"content-type header\"\r\n\r\n".data(using: .utf8)!)
        
        print("opening file...")
        if let bytes: [UInt8] = getFile(fileName: fileName) {
            for byte in bytes {
                data.append(byte)
            }
        }
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        
//        let json: [String:Any] = ["file_name": fileName,
//                                  "file_data": data,
//                                  "categories": self.CATEGORIES,
//                                  "auto_delete": deleteAfterProcessing]
//
//        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if self.check_err(data: data, response: response, error: error) { return }
            
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
    
    public func processDocumentURL(fileUrl: String?,
                                   fileUrls: [String]?,
                                   categories: [String] = [], //Fix categories default
                                   deleteAfterProcessing: Bool = false,
                                   boostMode: Int = 0,
                                   externalId: String?,
                                   maxPagesToProcess: Int?,
                                   withCompletion completion: @escaping (Data?, Error?) -> Void) {
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
            if self.check_err(data: data, response: response, error: error) { return }
            
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
    
    /**
     Update a document using ID and passing parameters
     Works but returns no output
     */
    public func updateDocument(documentId: String, params: [String: Any], withCompletion completion: @escaping (Data?, Error?) -> Void) {
        let headers: [String:String] = self.getHeaders()
        let api_url: String = "\(self.getUrl())/partner/documents/\(documentId)/"
        let url: URL = URL(string: api_url)!

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData
        session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if self.check_err(data: data, response: response, error: error) { return }

            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data!) as? [String: Any] else { //force unwrapping data
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }

                completion(prettyJsonData, nil)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }).resume()
    }
    
    /**
     Request to delete a document by ID
     */
    public func deleteDocument(documentId: String, withCompletion completion: @escaping (Data?, Error?) -> Void) {
        let headers: [String:String] = self.getHeaders()
        let api_url: String = "\(self.getUrl())/partner/documents/\(documentId)/"
        var components: URLComponents = URLComponents(string: api_url)!
        components.queryItems = [URLQueryItem(name: "id", value: documentId)]
        
        var request: URLRequest = URLRequest(url: components.url!)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if self.check_err(data: data, response: response, error: error){ return}
            
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data!) as? [String: Any] else { //force unwrapping data
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                
                print(prettyPrintedJson)
                completion(prettyJsonData, nil)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }).resume()
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
//    private func _request(http_verb: String, endpoint_name: String, request_arguments: [String:String]){
//
//        var headers = self._get_headers()
//        let api_url = "\(self._get_url())/partner\(endpoint_name)"
//        let url = URL(string: api_url)!
//
//        if self.client_secret != "" {
//            let timestamp = NSDate().timeIntervalSince1970
//            let myTimeInterval = TimeInterval(timestamp)
//            let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
////            let signature = self._generate_signature(request_arguments, timestamp=timestamp)
//            headers["X-Veryfi-Request-Timestamp"] = String(format: "%f", time)
////            headers["X-Veryfi-Request-Signature"] = signature
//        }
//
//        // Convert model to JSON data
//        guard let jsonData = try? JSONEncoder().encode(request_arguments) else {
//            print("Error: Trying to convert model to JSON data")
//            return
//        }
//        // Create the url request
//        var request = URLRequest(url: url)
//        request.httpMethod = http_verb
//        request.allHTTPHeaderFields = headers
//        request.httpBody = jsonData
////        request.timeoutInterval = self.timeout
//        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
//            guard error == nil else {
//                print("Error: error calling request")
//                print(error!)
//                return
//            }
//            guard let data = data else {
//                print("Error: Did not receive data")
//                return
//            }
//            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
//                print("Error: HTTP request failed")
//                return
//            }
//            do {
//                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                    print("Error: Cannot convert data to JSON object")
//                    return
//                }
//                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
//                    print("Error: Cannot convert JSON object to Pretty JSON data")
//                    return
//                }
//                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
//                    print("Error: Couldn't print JSON in String")
//                    return
//                }
//
//                print(prettyPrintedJson)
//            } catch {
//                print("Error: Trying to convert JSON data to string")
//                return
//            }
//        }).resume()
//    }
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
