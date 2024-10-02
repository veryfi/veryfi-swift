import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testProcessBankStatement() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "processBankStatement")
        }

        let expectation = XCTestExpectation(description: "Get data from processing bank statement")

        let url = Bundle.module.url(forResource: "bankstatement", withExtension: "pdf")!
        let fileData = try? Data(contentsOf: url)
        client.processBankStatement(fileName: "bankstatement.pdf", fileData: fileData!, withCompletion: { result in
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

        wait(for: [expectation], timeout: 60.0)
    }
}
