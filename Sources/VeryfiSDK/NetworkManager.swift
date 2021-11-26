import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public enum APIError: Error {
    case internalError
    case serverError
    case parsingError
}

enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum Endpoint: String {
    case documents = "/partner/documents/"
}

class NetworkManager {
    let credentials: VeryfiCredentials
    let apiVersion: String
    let baseUrl = "https://api.veryfi.com/api/"
    let session = URLSession.shared
    
    init(credentials: VeryfiCredentials, apiVersion:String) {
        self.credentials = credentials
        self.apiVersion = apiVersion
    }
    
    private func getUrl() -> String {
        return self.baseUrl + self.apiVersion
    }
    
    private func getHeaders() -> [String:String] {
        let headers = [
            "User-Agent": "Veryfi-Swift/0.0.1",
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Client-Id": self.credentials.clientId,
            "Authorization": "apikey \(self.credentials.username):\(self.credentials.apiKey)"
        ]
        return headers
    }
    
    func request(method: Method, route: Endpoint, queryItems: [URLQueryItem]? = nil, uploadData: Data? = nil, body: Data? = nil, queryItem: String? = "", completion: @escaping (Result<Data, APIError>) -> Void) {
        let headers = self.getHeaders()
        var apiUrl = "\(self.getUrl())\(route.rawValue)"
        if let queryItem = queryItem, queryItem != "" {
            apiUrl = apiUrl + queryItem + "/"
        }
        guard let url = URL(string: apiUrl) else {
            completion(.failure(.internalError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if (body != nil) {
            request.httpBody = body
        }
        if let uploadData = uploadData {
            session.uploadTask(with: request, from: uploadData, completionHandler: { data, response, error -> Void in
                self.processResponse(data: data, error: error, response: response, completion: completion)
            }).resume()
        } else {
            session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                self.processResponse(data: data, error: error, response: response, completion: completion)
            }).resume()
        }
    }
    
    func processResponse(data: Data?, error: Error?, response: URLResponse?, completion: @escaping (Result<Data, APIError>) -> Void) {

        guard error == nil, let data = data, let response = response as? HTTPURLResponse, (200 ..< 499) ~= response.statusCode else {
            completion(.failure(.serverError))
            return
        }
        completion(.success(data))
        return
    }
}
