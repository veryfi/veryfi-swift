import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

let clientId = "clientId"
let username = "username"
let apiKey = "apiKey"
let file = "receipt.jpeg"
let url = "https://cdn.veryfi.com/receipts/fd36b2c0-a84d-459c-9d57-c29ac5d14685/21c95fc5-0e5c-48f8-abe0-849e438296bf.jpeg"
let driverLicenseUrl = "https://cdn-dev.veryfi.com/testing/veryfi-python/driver_license.png"
let bankStatementUrl = "https://cdn-dev.veryfi.com/testing/veryfi-python/bankstatement.pdf"
let w2Url = "https://cdn.veryfi.com/wp-content/uploads/image.png"
let splitUrl = "https://cdn.veryfi.com/receipts/92233902-c94a-491d-a4f9-0d61f9407cd2.pdf"
let classifyUrl = "https://cdn.veryfi.com/receipts/92233902-c94a-491d-a4f9-0d61f9407cd2.pdf"
let checkUrl = "https://cdn-dev.veryfi.com/testing/veryfi-python/check.pdf"
var client = Client(clientId: clientId, username: username, apiKey: apiKey)
let mockResponses = true

class ClientSpy: Client {
    
    private var resource: String
    
    init(clientId: String, username: String, apiKey: String, resource: String) {
        self.resource = resource
        super.init(clientId: clientId, username: username, apiKey: apiKey)
    }
    
    override func processResponse(data: Data?, error: Error?, response: URLResponse?, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = Bundle.module.url(forResource: resource, withExtension: "json") else {
            completion(.success(Data()))
            return
        }
        let data = try? Data(contentsOf: url)
        completion(.success(data!))
    }
}

final class VeryfiSDKTests: XCTestCase {}
