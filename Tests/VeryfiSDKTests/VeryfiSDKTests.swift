import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

let clientId = "clientId"
let clientSecret = "clientSecret"
let username = "username"
let apiKey = "apiKey"
let file = "receipt.jpeg"
let url = "https://veryfi-testing-public.s3.us-west-2.amazonaws.com/receipt.jpg"
var client = Client(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey)
let mockResponses = true


class ClientSpy: Client {
    
    private var resource: String
    
    init(clientId: String, clientSecret: String, username: String, apiKey: String, resource: String) {
        self.resource = resource
        super.init(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey)
    }
    
    override func processResponse(data: Data?, error: Error?, response: URLResponse?, completion: @escaping (Result<Data, APIError>) -> Void) {
        let url = Bundle.module.url(forResource: resource, withExtension: "json")!
        let data = try? Data(contentsOf: url)
        completion(.success(data!))
    }
}


final class VeryfiSDKTests: XCTestCase {
    
    func testGetDocuments() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "getDocuments")
        }
        
        let expectation = XCTestExpectation(description: "Get all documents in a JSON array")
        
        client.getDocuments(withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                XCTAssertGreaterThanOrEqual(jsonResponse!.count, 2)
            case .failure(let error):
                print(error)
                XCTAssertTrue(false)
            }
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testGetDocument() {
        let expectation = XCTestExpectation(description: "Get a document by id in a JSON")
        
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "getDocument")
            let id = Int64(31727276)
            client.getDocument(documentId: String(id), withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let getDocumentId = jsonResponse?["id"] as? Int64 else {
                        XCTFail()
                        return
                    }
                    XCTAssertEqual(getDocumentId, id)
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(false)
                }
                expectation.fulfill()
            })
        } else {
            client.getDocuments(withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonDocuments = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let id = ((jsonDocuments?["documents"] as? NSArray)?[0] as? NSDictionary)?["id"] as? Int64 else {
                        XCTFail()
                        return
                    }
                    client.getDocument(documentId: String(id), withCompletion: { result in
                        switch result {
                        case .success(let data):
                            let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                            guard let getDocumentId = jsonResponse?["id"] as? Int64 else {
                                XCTFail()
                                return
                            }
                            XCTAssertEqual(getDocumentId, id)
                        case .failure(let error):
                            print(error)
                            XCTAssertTrue(false)
                        }
                    })
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(false)
                }
                expectation.fulfill()
            })
        }
        
        wait(for: [expectation], timeout: 40.0)
    }
    
    func testProcessDocument() {
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
                XCTAssertEqual("In-n-out Burger", vendor)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testUpdateDocument() {
        let expectation = XCTestExpectation(description: "Get data from update document")
        
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "updateDocument")
            let updateNotes = ["notes": "Note updated"]
            let id = 31727276
            client.updateDocument(documentId: String(id), params: updateNotes, withCompletion: { result in
                switch result {
                case .success(let data):
                    print(data)
                    XCTAssertTrue(true)
                case .failure(let error):
                    print(error)
                    XCTAssert(false)
                }
                expectation.fulfill()
            })
        } else {
            func generateRandomString() -> String {
                let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                return String((0..<10).map{ _ in letters.randomElement()! })
            }
            let notes = generateRandomString()
            let updateNotes = ["notes": notes]
            client.getDocuments(withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonDocuments = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let id = ((jsonDocuments?["documents"] as? NSArray)?[0] as? NSDictionary)?["id"] as? Int64 else {
                        XCTFail()
                        return
                    }
                    client.updateDocument(documentId: String(id), params: updateNotes, withCompletion: { result in
                        switch result {
                        case .success(let data):
                            print(data)
                            XCTAssertTrue(true)
                        case .failure(let error):
                            print(error)
                            XCTAssert(false)
                        }
                        expectation.fulfill()
                    })
                case .failure(let error):
                    print(error)
                }
            })
        }
        
        wait(for: [expectation], timeout: 40.0)
    }
    
    func testProcessDocumentURL() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "processDocument")
        }
        
        let expectation = XCTestExpectation(description: "Get a JSON response from process document")
        
        let categories = ["Advertising & Marketing", "Automotive"]
        client.processDocumentURL(fileUrl: url, categories: categories, deleteAfterProcessing: true, boostMode: 1, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let vendor = (jsonResponse?["vendor"] as? NSDictionary)?["name"] as? String else {
                    XCTFail()
                    break
                }
                XCTAssertEqual("In-n-out Burger", vendor)
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testDeleteDocument() {
        let expectationDocuments = XCTestExpectation(description: "Get documents")
        let expectationDelete = XCTestExpectation(description: "Get a JSON response from deleted document")
        
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "deleteDocument")
            let documentId = 31727276
            expectationDocuments.fulfill()
            client.deleteDocument(documentId: String(documentId), withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonStringDeleteResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let status = jsonStringDeleteResponse?["status"] as? String else {
                        XCTFail()
                        return
                    }
                    XCTAssertEqual("ok", status)
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(false)
                }
                expectationDelete.fulfill()
            })
        } else {
            client.processDocumentURL(fileUrl: url, withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let documentId = jsonResponse?["id"] as? Int64 else {
                        XCTFail()
                        return
                    }
                    client.deleteDocument(documentId: String(documentId), withCompletion: { result in
                        switch result {
                        case .success(let data):
                            let jsonStringDeleteResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                            guard let status = jsonStringDeleteResponse?["status"] as? String else {
                                XCTFail()
                                return
                            }
                            XCTAssertEqual("ok", status)
                        case .failure(let error):
                            print(error)
                            XCTAssertTrue(false)
                        }
                        expectationDelete.fulfill()
                    })
                case .failure(let error):
                    print(error)
                }
                expectationDocuments.fulfill()
            })
        }
        
        wait(for: [expectationDocuments, expectationDelete], timeout: 40.0)
    }
    
    func testGetDocumentLineItems() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "getDocumentLineItems")
        }
        
        let expectation = XCTestExpectation(description: "Get all line items from document")
        let documentId = 63480993
        client.getDocumentLineItems(documentId: String(documentId), withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                XCTAssertNotNil(jsonResponse!["line_items"])
            case .failure(let error):
                print(error)
                XCTAssertTrue(false)
            }
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testGetLineItem() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "getLineItem")
        }
        
        let expectation = XCTestExpectation(description: "Get line item from document")
        let documentId = 63480993
        let lineItemId = 190399931
        client.getLineItem(documentId: String(documentId), lineItemId: String(lineItemId), withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                XCTAssertGreaterThanOrEqual(jsonResponse!.count, 2)
            case .failure(let error):
                print(error)
                XCTAssertTrue(false)
            }
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testAddLineItem() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "addLineItem")
        }
        
        let expectation = XCTestExpectation(description: "Add line item to document")
        let documentId = 63480993
        var params = LineItem()
        params.order = 20
        params.description = "Test"
        params.total = 44.4
        params.sku = "testsku"
        client.addLineItem(documentId: String(documentId), params: params, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                if mockResponses {
                    XCTAssertGreaterThanOrEqual(jsonResponse!.count, 2)
                } else {
                    XCTAssertEqual(jsonResponse!["total"] as? Float, params.total)
                    XCTAssertEqual(jsonResponse!["description"] as? String, params.description)
                }
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testUpdateLineItem() {
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "addLineItem")
        }
        
        let expectation = XCTestExpectation(description: "Add line item to document")
        let documentId = 63480993
        let lineItemId = 190399931
        var params = LineItem()
        params.description = "Test"
        client.updateLineItem(documentId: String(documentId), lineItemId: String(lineItemId), params: params, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                if mockResponses {
                    XCTAssertGreaterThanOrEqual(jsonResponse!.count, 2)
                } else {
                    XCTAssertEqual(jsonResponse!["description"] as? String, params.description)
                }
            case .failure(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testDeleteDocumentLineItems() {
        let expectationDocuments = XCTestExpectation(description: "Get documents")
        let expectationDelete = XCTestExpectation(description: "Get a JSON response from deleted document")
        
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "deleteDocumentLineItems")
            let documentId = 63480993
            expectationDocuments.fulfill()
            client.deleteDocumentLineItems(documentId: String(documentId), withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonStringDeleteResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let status = jsonStringDeleteResponse?["status"] as? String else {
                        XCTFail()
                        return
                    }
                    XCTAssertEqual("ok", status)
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(false)
                }
                expectationDelete.fulfill()
            })
        } else {
            client.processDocumentURL(fileUrl: url, withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let documentId = jsonResponse?["id"] as? Int64 else {
                        XCTFail()
                        return
                    }
                    client.deleteDocumentLineItems(documentId: String(documentId), withCompletion: { result in
                        switch result {
                        case .success(let data):
                            let jsonStringDeleteResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                            guard let status = jsonStringDeleteResponse?["status"] as? String else {
                                XCTFail()
                                return
                            }
                            XCTAssertEqual("ok", status)
                        case .failure(let error):
                            print(error)
                            XCTAssertTrue(false)
                        }
                        expectationDelete.fulfill()
                    })
                case .failure(let error):
                    print(error)
                }
                expectationDocuments.fulfill()
            })
        }
        
        wait(for: [expectationDocuments, expectationDelete], timeout: 40.0)
    }
    
    func testDeleteLineItem() {
        let expectationDocuments = XCTestExpectation(description: "Get documents")
        let expectationDelete = XCTestExpectation(description: "Get a JSON response from deleted document")
        
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "deleteLineItem")
            let documentId = 63480993
            let lineItemId = 190399931
            expectationDocuments.fulfill()
            client.deleteLineItem(documentId: String(documentId), lineItemId: String(lineItemId), withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonStringDeleteResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let status = jsonStringDeleteResponse?["status"] as? String else {
                        XCTFail()
                        return
                    }
                    XCTAssertEqual("ok", status)
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(false)
                }
                expectationDelete.fulfill()
            })
        } else {
            let documentId = 63480993
            var params = LineItem()
            params.order = 20
            params.description = "Test"
            params.total = 44.4
            params.sku = "testsku"
            client.addLineItem(documentId: String(documentId), params: params, withCompletion: { result in
                switch result {
                case .success(let data):
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let lineItemId = jsonResponse?["id"] as? Int64 else {
                        XCTFail()
                        return
                    }
                    client.deleteLineItem(documentId: String(documentId), lineItemId: String(lineItemId), withCompletion: { result in
                        switch result {
                        case .success(let data):
                            let jsonStringDeleteResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                            guard let status = jsonStringDeleteResponse?["status"] as? String else {
                                XCTFail()
                                return
                            }
                            XCTAssertEqual("ok", status)
                        case .failure(let error):
                            print(error)
                            XCTAssertTrue(false)
                        }
                        expectationDelete.fulfill()
                    })
                case .failure(let error):
                    print(error)
                }
                expectationDocuments.fulfill()
            })
        }
        
        wait(for: [expectationDocuments, expectationDelete], timeout: 40.0)
    }
    
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
