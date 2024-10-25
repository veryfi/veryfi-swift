//
//  ProcessW9Url.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Upload w9 document to Veryfi API with URL.
    /// - Parameters:
    ///   - fileUrl: Publicly available URL.
    ///   - fileUrls: List of publicly available URLs.
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func processW9URL(fileUrl: String? = nil,
                                   fileUrls: [String]? = nil,
                                   withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let params: [String: Any] = [
            "file_url": fileUrl as Any, //implicit coerce
            "file_urls": fileUrls as Any, //implicit coerce
        ] //implicit coerce
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        self.request(method: .POST, route: .w9s, body: jsonData, completion: completion)
    }
}
