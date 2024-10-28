import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testGetDocumentLineItems() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "getDocumentLineItems")
        }

        let expectation = XCTestExpectation(description: "Get all line items from document")
        let documentId = 63480993
        client.getDocumentLineItems(documentId: String(documentId), withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                XCTAssertNotNil(jsonResponse!["line_items"])
            case .failure(let error):
                print(error)
                XCTAssertTrue(false)
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)
    }
}
