import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testDeleteCheck() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "noData")
        }

        let expectation = XCTestExpectation(description: "Delete check by ID")

        client.deleteCheck(checkId: 6698654, withCompletion: { result in
            switch result {
            case .success(let data):
                XCTAssertTrue(data.isEmpty)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
} 
