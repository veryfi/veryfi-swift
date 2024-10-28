import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testAddLineItem() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "addLineItem")
        }

        let expectation = XCTestExpectation(description: "Add line item to document")
        let documentId = 63480993
        let params = AddLineItem(order: 20, description: "Test", total: 44.0)
        params.sku = "testsku"
        client.addLineItem(documentId: String(documentId), params: params, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                if mockResponses {
                    XCTAssertGreaterThanOrEqual(jsonResponse!.count, 2)
                } else {
                    XCTAssertEqual(jsonResponse!["total"] as? Float, params.total)
                    XCTAssertEqual(jsonResponse!["description"] as? String, params.description)
                }
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)
    }
}
