//
//  NetworkManager.swift
//  
//
//  Created by Diego Giraldo Gómez on 3/11/21.
//

import Foundation

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

struct NetworkManager {
    let credentials: VeryfiCredentials
    let session = URLSession.shared
    
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
        let apiUrl = "\(Constants.url)\(route.rawValue)\(String(describing: queryItem))"
        guard let url = URL(string: apiUrl) else {
            completion(.failure(.internalError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let uploadData = uploadData {
            session.uploadTask(with: request, from: uploadData, completionHandler: { data, response, error -> Void in
                processResponse(data: data, error: error, response: response, completion: completion)
            }).resume()
        } else {
            session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                processResponse(data: data, error: error, response: response, completion: completion)
            }).resume()
        }
    }
    
    private func processResponse(data: Data?, error: Error?, response: URLResponse?, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard error == nil, let data = data, let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
            completion(.failure(.serverError))
            return
        }
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                completion(.failure(.parsingError))
                return
            }
            guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                completion(.failure(.parsingError))
                return
            }
            completion(.success(prettyJsonData))
        } catch {
            completion(.failure(.parsingError))
            return
        }
    }
}
