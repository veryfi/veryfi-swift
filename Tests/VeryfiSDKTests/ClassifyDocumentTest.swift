import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

extension VeryfiSDKTests {
    func testClassifyDocument() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "classify")
        }

        let expectation = XCTestExpectation(description: "Get data from classifying document")

        let url = Bundle.module.url(forResource: "receipt", withExtension: "jpeg")!
        let fileData = try? Data(contentsOf: url)
        client.classifyDocument(fileName: file, fileData: fileData!, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let documentType = jsonResponse?["document_type"] as? NSDictionary else {
                    XCTFail()
                    break
                }
                XCTAssertEqual("receipt", documentType["value"] as? String)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
    
    func testClassifyDocumentURL() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, username: username, apiKey: apiKey, resource: "classify")
        }

        let expectation = XCTestExpectation(description: "Get data from classifying document URL")

        client.classifyDocumentURL(fileUrl: classifyUrl, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let documentType = jsonResponse?["document_type"] as? NSDictionary else {
                    XCTFail()
                    break
                }
                XCTAssertEqual("invoice", documentType["value"] as? String)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 60.0)
    }
} 
