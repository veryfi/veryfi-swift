//
//  ProcessContractUrl.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Upload a contract from URL for the Veryfi API to process.
    /// https://docs.veryfi.com/api/contracts/process-a-contract/
    /// - Parameters:
    ///     - fileUrl: URL of the file to upload to the Veryfi API.
    ///     - fileUrls: Array of URLs to publicly accessible documents.
    ///     - deleteAfterProcessing: Do not store file in Veryfi's inbox.
    ///     - maxPagesToProcess: Limit processing to number of pages (1-50, default 50).
    ///     - externalId: External ID to associate with the document.
    ///     - params: Additional parameters.
    ///     - completion: Function called after request completes.
    ///     -  detail: Response from server.
    ///     -  error: Error from server.
    public func processContractURL(fileUrl: String? = nil,
                                  fileUrls: [String]? = nil,
                                  deleteAfterProcessing: Bool = false,
                                  maxPagesToProcess: Int = 50,
                                  externalId: String? = nil,
                                  params: [String: Any]? = nil,
                                  withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        var requestParams = params ?? [String: Any]()
        requestParams["auto_delete"] = deleteAfterProcessing
        requestParams["max_pages_to_process"] = maxPagesToProcess
        
        if let fileUrl = fileUrl {
            requestParams["file_url"] = fileUrl
        }
        
        if let fileUrls = fileUrls {
            requestParams["file_urls"] = fileUrls
        }
        
        if let externalId = externalId {
            requestParams["external_id"] = externalId
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestParams, options: .prettyPrinted) else {
            completion(.failure(.parsingError))
            return
        }

        self.request(method: .POST, route: .contracts, uploadData: jsonData, completion: completion)
    }
} 