import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

let clientId = "clientId"
let clientSecret = "clientSecret"
let username = "username"
let apiKey = "apiKey"
let file = "receipt.jpeg"
let url = "https://cdn.veryfi.com/receipts/fd36b2c0-a84d-459c-9d57-c29ac5d14685/21c95fc5-0e5c-48f8-abe0-849e438296bf.jpeg"
let driverLicenseUrl = "https://cdn-dev.veryfi.com/testing/veryfi-python/driver_license.png"
let bankStatementUrl = "https://cdn-dev.veryfi.com/testing/veryfi-python/bankstatement.pdf"
let w2Url = "https://cdn.veryfi.com/wp-content/uploads/image.png"
var client = Client(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey)
let mockResponses = true

class ClientSpy: Client {
    
    private var resource: String
    
    init(clientId: String, clientSecret: String, username: String, apiKey: String, resource: String) {
        self.resource = resource
        super.init(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey)
    }
    
    override func processResponse(data: Data?, error: Error?, response: URLResponse?, completion: @escaping (Result<Data, APIError>) -> Void) {
        let url = Bundle.module.url(forResource: resource, withExtension: "json")!
        let data = try? Data(contentsOf: url)
        completion(.success(data!))
    }
}

final class VeryfiSDKTests: XCTestCase {}
