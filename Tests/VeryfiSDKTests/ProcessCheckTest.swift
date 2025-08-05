import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testProcessCheck() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "processCheck")
        }

        let expectation = XCTestExpectation(description: "Get data from processing check")

        let url = Bundle.module.url(forResource: "check", withExtension: "pdf")!
        let fileData = try? Data(contentsOf: url)
        client.processCheck(fileName: "check.pdf", fileData: fileData!, deleteAfterProcessing: true, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let number = (jsonResponse?["check_number"] as? String) else {
                    XCTFail()
                    break
                }
                XCTAssertEqual("118408359", number)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
    
    func testProcessCheckURL() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "processCheck")
        }

        let expectation = XCTestExpectation(description: "Get data from processing check URL")

        client.processCheckURL(fileUrl: checkUrl, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let number = (jsonResponse?["check_number"] as? String) else {
                    XCTFail()
                    break
                }
                XCTAssertEqual("118408359", number)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
} 
