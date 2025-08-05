import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testGetBankStatement() {
        let expectation = XCTestExpectation(description: "Get a bank statement by id in a JSON")

        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "getBankStatement")
            let id = Int64(4560116)
            client.getBankStatement(id: String(id), withCompletion: { result in
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
            client.getBankStatements(withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonDocuments = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let id = ((jsonDocuments?["results"] as? NSArray)?[0] as? NSDictionary)?["id"] as? Int64 else {
                        XCTFail()
                        return
                    }
                    client.getBankStatement(id: String(id), withCompletion: { result in
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
