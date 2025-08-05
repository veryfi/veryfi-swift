//
//  ProcessW8BenEUrl.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Upload w8BenE document to Veryfi API with URL.
    /// https://docs.veryfi.com/api/w-8ben-e/process-a-w-8-ben-e/
    /// - Parameters:
    ///   - fileUrl: Publicly available URL.
    ///   - fileUrls: List of publicly available URLs.
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func processW8BenEURL(fileUrl: String? = nil,
                                 fileUrls: [String]? = nil,
                                 withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let params: [String: Any] = [
            "file_url": fileUrl as Any, //implicit coerce
            "file_urls": fileUrls as Any, //implicit coerce
        ] //implicit coerce
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        self.request(method: .POST, route: .w8BenE, body: jsonData, completion: completion)
    }
}
