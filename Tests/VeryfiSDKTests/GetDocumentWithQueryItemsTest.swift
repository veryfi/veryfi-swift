import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testGetDocumentWithQueryItems() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "getDocuments")
        }

        let expectation = XCTestExpectation(description: "Get all documents in a JSON array")
        let queryItems = [URLQueryItem(name: "order_by", value: "created")]
        client.getDocuments(queryItems: queryItems, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                XCTAssertGreaterThanOrEqual(jsonResponse!.count, 2)
            case .failure(let error):
                print(error)
                XCTAssertTrue(false)
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)
    }
}
