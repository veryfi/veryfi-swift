import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testDeleteLineItem() {
        let expectationDocuments = XCTestExpectation(description: "Get documents")
        let expectationDelete = XCTestExpectation(description: "Get a JSON response from deleted document")

        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "deleteLineItem")
            let documentId = 63480993
            let lineItemId = 190399931
            expectationDocuments.fulfill()
            client.deleteLineItem(documentId: String(documentId), lineItemId: String(lineItemId), withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonStringDeleteResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let status = jsonStringDeleteResponse?["status"] as? String else {
                        XCTFail()
                        return
                    }
                    XCTAssertEqual("ok", status)
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(false)
                }
                expectationDelete.fulfill()
            })
        } else {
            let documentId = 63480993
            let params = AddLineItem(order: 20, description: "Test", total: 44.4)
            params.sku = "testsku"
            client.addLineItem(documentId: String(documentId), params: params, withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let lineItemId = jsonResponse?["id"] as? Int64 else {
                        XCTFail()
                        return
                    }
                    client.deleteLineItem(documentId: String(documentId), lineItemId: String(lineItemId), withCompletion: { result in
                        switch result {
                        case .success(let data):
                            let jsonStringDeleteResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                            guard let status = jsonStringDeleteResponse?["status"] as? String else {
                                XCTFail()
                                return
                            }
                            XCTAssertEqual("ok", status)
                        case .failure(let error):
                            print(error)
                            XCTAssertTrue(false)
                        }
                        expectationDelete.fulfill()
                    })
                case .failure(let error):
                    print(error)
                }
                expectationDocuments.fulfill()
            })
        }

        wait(for: [expectationDocuments, expectationDelete], timeout: 40.0)
    }
}
