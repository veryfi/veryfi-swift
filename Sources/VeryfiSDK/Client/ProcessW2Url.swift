//
//  ProcessW2Url.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
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
    public func processW2URL(fileUrl: String? = nil,
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
}
