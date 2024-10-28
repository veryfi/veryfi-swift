import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testGetW2() {
        let expectation = XCTestExpectation(description: "Get a w2 document by id in a JSON")

        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "getW2")
            let id = Int64(4609400)
            client.getW2(documentId: String(id), withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let getDocumentId = jsonResponse?["id"] as? Int64 else {
                        XCTFail()
                        return
                    }
                    XCTAssertEqual(getDocumentId, id)
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(false)
                }
                expectation.fulfill()
            })
        } else {
            client.getW2s(queryItems: [URLQueryItem(name: "page_size", value: "1")], withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonDocuments = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let id = ((jsonDocuments?["results"] as? NSArray)?[0] as? NSDictionary)?["id"] as? Int64 else {
                        XCTFail()
                        return
                    }
                    client.getW2(documentId: String(id), withCompletion: { result in
                        switch result {
                        case .success(let data):
                            let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                            guard let getDocumentId = jsonResponse?["id"] as? Int64 else {
                                XCTFail()
                                return
                            }
                            XCTAssertEqual(getDocumentId, id)
                        case .failure(let error):
                            print(error)
                            XCTAssertTrue(false)
                        }
                    })
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(false)
                }
                expectation.fulfill()
            })
        }

        wait(for: [expectation], timeout: 40.0)
    }
}
