//
//  ProcessDocumentUrl.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Upload document to Veryfi API with URL.
    /// https://docs.veryfi.com/api/receipts-invoices/process-a-document/
    /// - Parameters:
    ///   - fileUrl: Publicly available URL.
    ///   - fileUrls: List of publicly available URLs.
    ///   - categories: List of document categories.
    ///   - deleteAfterProcessing: Do not store file in Veryfi's inbox.
    ///   - boostMode: Skip data enrichment but process document faster.
    ///   - externalId: Existing ID to assign to document.
    ///   - maxPagesToProcess: Number of pages to process.
    ///   - thinking: Extra LLM pass on the line items: `.light` or `.deep` (slower). Pass `nil` to turn it off. Needs thinking mode enabled for your account.
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
                                   thinking: ThinkingMode? = nil,
                                   withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        var params: [String: Any] = ["auto_delete": deleteAfterProcessing,
                                     "boost_mode": boostMode,
                                     "categories": categories ?? [],
                                     "external_id": externalId as Any, //implicit coerce
                                     "file_url": fileUrl as Any, //implicit coerce
                                     "file_urls": fileUrls as Any, //implicit coerce
                                     "max_pages_to_process": maxPagesToProcess as Any] //implicit coerce
        if let thinking = thinking {
            params["thinking"] = thinking.rawValue
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        self.request(method: .POST, route: .documents, body: jsonData, completion: completion)
    }
}
