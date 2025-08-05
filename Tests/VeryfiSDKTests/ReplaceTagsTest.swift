import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testReplaceTags() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "replaceTags")
        }

        let expectation = XCTestExpectation(description: "Get a JSON response from replace tags")

        client.replaceTags(documentId: "253736946", params: ["replace_tag"], withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let tags = jsonResponse?["tags"] as? [[String: Any]]
                XCTAssertTrue((tags?.first?["name"] as? String)?.lowercased() == "replace_tag")
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)
    }
}
