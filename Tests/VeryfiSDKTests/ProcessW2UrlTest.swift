import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testProcessW2URL() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "processW2")
        }

        let expectation = XCTestExpectation(description: "Get a JSON response from process a w2 document")

        client.processW2URL(fileUrl: w2Url, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let employerName = jsonResponse?["employer_name"] as? String else {
                    XCTFail()
                    break
                }

                XCTAssertEqual("The Big Company", employerName)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)
    }
}
