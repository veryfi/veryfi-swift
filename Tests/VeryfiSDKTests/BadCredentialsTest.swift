import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testBadCredentials() {
        let expectation = XCTestExpectation(description: "Get response to a bad credential case")
        let badClient = Client(clientId: "badClientId", clientSecret: "badClientSecret", username: "badUsername", apiKey: "badApiKey")
        badClient.getDocuments(withCompletion: { result in
            switch result{
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let status = jsonResponse?["status"] as? String, let message = jsonResponse?["message"] as? String else {
                    XCTFail()
                    return
                }
                XCTAssertEqual("fail", status)
                XCTAssertEqual("Not Authorized", message)
            case .failure(let error):
                print(error)
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)
    }
}
