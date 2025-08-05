import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testProcessBankStatementURL() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "processBankStatement")
        }

        let expectation = XCTestExpectation(description: "Get a JSON response from process bank statement")

        client.processBankStatementURL(fileUrl: bankStatementUrl, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                XCTAssertTrue(jsonResponse?["account_holder_name"] as? String == "Mr Robot Roboto")
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)
    }
}
