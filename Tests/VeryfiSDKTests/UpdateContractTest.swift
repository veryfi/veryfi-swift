import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testUpdateContract() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "updateContract")
        }

        let expectation = XCTestExpectation(description: "Update a contract")

        let updateParams: [String: Any] = [
            "meta": [
              "tags" : ["updated"]
            ]
        ]

        client.updateContract(contractId: 6737339, params: updateParams, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let tags = (jsonResponse?["meta"] as? NSDictionary)?["tags"] as? [String] else {
                    XCTFail()
                    break
                }
                XCTAssertEqual("updated", tags.first?.lowercased() ?? "")
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
} 
