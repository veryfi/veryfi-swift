import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testProcessAnyDocument() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "processAnyDocument")
        }

        let expectation = XCTestExpectation(description: "Get data from processing any document")

        let url = Bundle.module.url(forResource: "driver_license", withExtension: "png")!
        let fileData = try! Data(contentsOf: url)
        client.processAnyDocument(fileName: "driver_license.png", fileData: fileData, templateName: "us_driver_license", withCompletion: { result in
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

        wait(for: [expectation], timeout: 60.0)
    }
}
