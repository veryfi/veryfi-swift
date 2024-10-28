import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testAddTags() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "addTags")
        }

        let expectation = XCTestExpectation(description: "Get a JSON response from add tags")

        client.addTags(documentId: "31727276", params: AddTags(tags: ["tag_1", "tag_2"]), withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let results = jsonResponse?["tags"] as? [[String: Any]]
                XCTAssertEqual(results?.count ?? 0, 2)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)
    }
}
