import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testDeleteDocumentLineItems() {
        let expectationDocuments = XCTestExpectation(description: "Get documents")
        let expectationDelete = XCTestExpectation(description: "Get a JSON response from deleted document")

        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "deleteDocumentLineItems")
            let documentId = 63480993
            expectationDocuments.fulfill()
            client.deleteDocumentLineItems(documentId: String(documentId), withCompletion: { result in
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
            client.processDocumentURL(fileUrl: url, withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let documentId = jsonResponse?["id"] as? Int64 else {
                        XCTFail()
                        return
                    }
                    client.deleteDocumentLineItems(documentId: String(documentId), withCompletion: { result in
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
