//
//  ProcessBankStatementUrl.swift
//  VeryfiSDK
//
//  Created by Veryfi on 25/10/24.
//
import Foundation

extension Client {
    /// Upload bank statement to Veryfi API with URL.
    /// https://docs.veryfi.com/api/bank-statements/process-a-bank-statement/
    /// - Parameters:
    ///   - fileUrl: Publicly available URL.
    ///   - fileUrls: List of publicly available URLs.
    ///   - confidenceDetails: Confidence details object
    ///   - completion: Block executed after request.
    ///   - detail: Response from server.
    ///   - error: Error from server.
    public func processBankStatementURL(fileUrl: String? = nil,
                                   fileUrls: [String]? = nil,
                                   boundingBoxes: Bool = false,
                                   confidenceDetails: Bool = false,
                                   withCompletion completion: @escaping (Result<Data, APIError>) -> Void) {
        let params: [String: Any] = [
                                     "bounding_boxes": boundingBoxes,
                                     "confidence_details": confidenceDetails,
                                     "file_url": fileUrl as Any, //implicit coerce
                                     "file_urls": fileUrls as Any, //implicit coerce
                                   ] //implicit coerce
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        self.request(method: .POST, route: .bankStatements, body: jsonData, completion: completion)
    }
}
