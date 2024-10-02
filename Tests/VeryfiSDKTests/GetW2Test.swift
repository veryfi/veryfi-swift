import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testGetW2() {
        let expectation = XCTestExpectation(description: "Get a document by id in a JSON")

        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "getDocument")
            let id = Int64(31727276)
            client.getDocument(documentId: String(id), withCompletion: { result in
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
            client.getDocuments(queryItems: [URLQueryItem(name: "page_size", value: "1")], withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonDocuments = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let id = ((jsonDocuments?["documents"] as? NSArray)?[0] as? NSDictionary)?["id"] as? Int64 else {
                        XCTFail()
                        return
                    }
                    client.getDocument(documentId: String(id), withCompletion: { result in
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
