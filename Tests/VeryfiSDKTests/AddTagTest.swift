import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testAddTag() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "addTag")
        }

        let expectation = XCTestExpectation(description: "Get a JSON response from add tag")

        client.addTag(documentId: "31727276", params: AddTag(name: "test_tag"), withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                XCTAssertTrue((jsonResponse?["name"] as? String)?.lowercased() == "test_tag")
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)
    }
}
