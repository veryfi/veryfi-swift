import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testProcessContract() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "processContract")
        }

        let expectation = XCTestExpectation(description: "Get data from processing contract")

        let url = Bundle.module.url(forResource: "contract", withExtension: "pdf")!
        let fileData = try? Data(contentsOf: url)
        client.processContract(fileName: "contract.pdf", fileData: fileData!, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let contractName = (jsonResponse?["contract_name"] as? NSDictionary)?["value"] as? String else {
                    XCTFail()
                    break
                }
                XCTAssertEqual("Service Agreement Contract", contractName)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
} 
