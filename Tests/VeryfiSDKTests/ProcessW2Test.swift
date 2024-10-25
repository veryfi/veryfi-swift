import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testProcessW2() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "processW2")
        }

        let expectation = XCTestExpectation(description: "Get data from processing a w2 document")

        let url = Bundle.module.url(forResource: "w2", withExtension: "png")!
        let fileData = try? Data(contentsOf: url)
        client.processW2(fileName: file, fileData: fileData!, withCompletion: { result in
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

        wait(for: [expectation], timeout: 60.0)
    }
}
