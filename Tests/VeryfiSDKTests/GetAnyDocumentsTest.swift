import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testGetAnyDocuments() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "getAnyDocuments")
        }

        let expectation = XCTestExpectation(description: "Get all any documents in a JSON array")

        client.getAnyDocuments(withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let results = jsonResponse?["results"] as? [[String: Any]]
                XCTAssertGreaterThanOrEqual(results?.count ?? 0, 2)
                XCTAssertTrue(results?.first?["template_name"] as? String == "us_driver_license")
            case .failure(let error):
                print(error)
                XCTAssertTrue(false)
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)
    }
}
