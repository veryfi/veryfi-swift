import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testDeleteContract() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "deleteContract")
        }

        let expectation = XCTestExpectation(description: "Delete a contract")

        client.deleteContract(contractId: 6737027, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonStringDeleteResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let status = jsonStringDeleteResponse?["status"] as? String else {
                    XCTFail()
                    return
                }
                XCTAssertEqual("ok", status)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
} 
