import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testUpdateDocument() {
        let expectation = XCTestExpectation(description: "Get data from update document")

        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "updateDocument")
            let updateNotes = ["notes": "Note updated"]
            let id = 31727276
            client.updateDocument(documentId: String(id), params: updateNotes, withCompletion: { result in
                switch result {
                case .success(let data):
                    print(data)
                    XCTAssertTrue(true)
                case .failure(let error):
                    print(error)
                    XCTAssert(false)
                }
                expectation.fulfill()
            })
        } else {
            func generateRandomString() -> String {
                let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                return String((0..<10).map{ _ in letters.randomElement()! })
            }
            let notes = generateRandomString()
            let updateNotes = ["notes": notes]
            client.getDocuments(withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonDocuments = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let id = ((jsonDocuments?["documents"] as? NSArray)?[0] as? NSDictionary)?["id"] as? Int64 else {
                        XCTFail()
                        return
                    }
                    client.updateDocument(documentId: String(id), params: updateNotes, withCompletion: { result in
                        switch result {
                        case .success(let data):
                            print(data)
                            XCTAssertTrue(true)
                        case .failure(let error):
                            print(error)
                            XCTAssert(false)
                        }
                        expectation.fulfill()
                    })
                case .failure(let error):
                    print(error)
                }
            })
        }

        wait(for: [expectation], timeout: 40.0)
    }
}
