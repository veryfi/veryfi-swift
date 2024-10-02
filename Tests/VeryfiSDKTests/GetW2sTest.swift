import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testGetW2s() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "getDocuments")
        }

        let expectation = XCTestExpectation(description: "Get all documents in a JSON array")

        client.getDocuments(withCompletion: { result in
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

        wait(for: [expectation], timeout: 120.0)
    }
}
