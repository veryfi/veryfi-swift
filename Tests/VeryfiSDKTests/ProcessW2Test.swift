import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testProcessW2() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "processDocument")
        }

        let expectation = XCTestExpectation(description: "Get data from processing document")

        let url = Bundle.module.url(forResource: "receipt", withExtension: "jpeg")!
        let fileData = try? Data(contentsOf: url)
        let categories = ["Advertising & Marketing", "Automotive"]
        client.processDocument(fileName: file, fileData: fileData!, categories: categories, deleteAfterProcessing: true, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let vendor = (jsonResponse?["vendor"] as? NSDictionary)?["name"] as? String else {
                    XCTFail()
                    break
                }
                XCTAssertEqual("Walgreens", vendor)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
}
