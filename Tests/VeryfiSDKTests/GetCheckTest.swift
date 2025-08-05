import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testGetCheck() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "getCheck")
        }

        let expectation = XCTestExpectation(description: "Get check by ID")

        client.getCheck(checkId: 123456, withCompletion: { result in
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
    
    func testGetChecks() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "getChecks")
        }

        let expectation = XCTestExpectation(description: "Get all checks")

        client.getChecks(withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let count = (jsonResponse?["count"] as? Int) else {
                    XCTFail()
                    break
                }
                XCTAssertLessThan(5, count)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
} 
