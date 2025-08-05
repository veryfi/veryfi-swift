import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testUpdateLineItem() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "addLineItem")
        }

        let expectation1 = XCTestExpectation(description: "Add line item to document")
        let documentId = 63480993
        var lineItemId = 0
        let params1 = AddLineItem(order: 20, description: "Test", total: 44.0)
        params1.sku = "testsku"
        client.addLineItem(documentId: String(documentId), params: params1, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                if mockResponses {
                    XCTAssertGreaterThanOrEqual(jsonResponse!.count, 2)
                } else {
                    lineItemId = jsonResponse!["id"] as? Int ?? 0
                }
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation1.fulfill()
        })
        wait(for: [expectation1], timeout: 20.0)

        let expectation2 = XCTestExpectation(description: "Update line item to document")
        let params2 = UpdateLineItem()
        params2.description = "Test"
        client.updateLineItem(documentId: String(documentId), lineItemId: String(lineItemId), params: params2, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                if mockResponses {
                    XCTAssertGreaterThanOrEqual(jsonResponse!.count, 2)
                } else {
                    XCTAssertEqual(jsonResponse!["description"] as? String, params2.description)
                }
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation2.fulfill()
        })

        wait(for: [expectation2], timeout: 20.0)
    }
}
