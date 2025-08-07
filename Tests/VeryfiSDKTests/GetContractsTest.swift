import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testGetContracts() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "getContracts")
        }

        let expectation = XCTestExpectation(description: "Get all contracts in a JSON array")

        client.getContracts(withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let results = jsonResponse?["results"] as? [[String: Any]]
                guard let contractName = (results?.first?["contract_name"] as? NSDictionary)?["value"] as? String else {
                    XCTFail()
                    break
                }
                XCTAssertEqual("Service Agreement Contract", contractName)
            case .failure(let error):
                print(error)
                XCTAssertTrue(false)
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 120.0)
    }
} 
