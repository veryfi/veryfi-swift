import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testProcessDocumentURL() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "processDocument")
        }

        let expectation = XCTestExpectation(description: "Get a JSON response from process document")

        let categories = ["Advertising & Marketing", "Automotive"]
        client.processDocumentURL(fileUrl: url, categories: categories, deleteAfterProcessing: true, boostMode: 1, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let vendor = (jsonResponse?["vendor"] as? NSDictionary)?["name"] as? String else {
                    XCTFail()
                    break
                }
                XCTAssertEqual("Walgreens", vendor)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)
    }
}
