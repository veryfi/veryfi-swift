import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testGetLineItem() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "getLineItem")
        }

        let expectation = XCTestExpectation(description: "Get line item from document")
        let documentId = 63480993
        let lineItemId = 190399931
        client.getLineItem(documentId: String(documentId), lineItemId: String(lineItemId), withCompletion: { result in
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
