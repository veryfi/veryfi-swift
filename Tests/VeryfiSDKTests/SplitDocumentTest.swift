import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testSplitDocument() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "split")
        }

        let expectation = XCTestExpectation(description: "Get data from splitting document")

        let url = Bundle.module.url(forResource: "split", withExtension: "pdf")!
        let fileData = try? Data(contentsOf: url)
        client.splitDocument(fileName: file, fileData: fileData!, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let splitId = jsonResponse?["id"] as? Int else {
                    XCTFail()
                    break
                }
                XCTAssertEqual(351609, splitId)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
    
    func testSplitDocumentURL() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "split")
        }

        let expectation = XCTestExpectation(description: "Get data from splitting document URL")

        client.splitDocumentURL(fileUrl: splitUrl, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let splitId = jsonResponse?["id"] as? Int else {
                    XCTFail()
                    break
                }
                XCTAssertEqual(351609, splitId)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
    
    func testGetSplitDocument() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "getSplit")
        }

        let expectation = XCTestExpectation(description: "Get split document by ID")

        client.getSplitDocument(splitId: 351609, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let splitId = jsonResponse?["id"] as? Int else {
                    XCTFail()
                    break
                }
                XCTAssertEqual(351609, splitId)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
    
    func testGetSplitDocuments() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "getSplits")
        }

        let expectation = XCTestExpectation(description: "Get all split documents")

        client.getSplitDocuments(withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let count = jsonResponse?["count"] as? Int else {
                    XCTFail()
                    break
                }
                XCTAssertLessThan(8, count)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
} 
