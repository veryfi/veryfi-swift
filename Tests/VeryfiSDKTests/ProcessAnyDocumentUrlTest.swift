import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testProcessAnyDocumentURL() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "processAnyDocument")
        }

        let expectation = XCTestExpectation(description: "Get a JSON response from process any document")

        client.processAnyDocumentURL(fileUrl: driverLicenseUrl, templateName: "us_driver_license", withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                XCTAssertTrue(jsonResponse?["last_name"] as? String == "McLovin")
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)
    }
}
