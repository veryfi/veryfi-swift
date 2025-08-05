import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testGetBankStatements() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "getBankStatements")
        }

        let expectation = XCTestExpectation(description: "Get all bank statements in a JSON array")

        client.getBankStatements(withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let results = jsonResponse?["results"] as? [[String: Any]]
                XCTAssertGreaterThanOrEqual(results?.count ?? 0, 2)
                XCTAssertTrue(results?.first?["bank_vat_number"] as? String == "SC327000")
                XCTAssertGreaterThanOrEqual(jsonResponse!.count, 2)
            case .failure(let error):
                print(error)
                XCTAssertTrue(false)
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)
    }
}
