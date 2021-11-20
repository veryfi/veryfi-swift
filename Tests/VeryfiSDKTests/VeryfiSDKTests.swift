import XCTest
@testable import VeryfiSDK

let clientId = "clientId"
let clientSecret = "clientSecret"
let username = "username"
let apiKey = "apiKey"
let file = "receipt.jpeg"
let url = "https://veryfi-testing-public.s3.us-west-2.amazonaws.com/receipt.jpg"
var client = Client(clientId:clientId, clientSecret:clientSecret, username:username, apiKey:apiKey)
let mockResponses = true

class ClientSpy: Client {
    
    private var resource: String
    
    init(clientId: String, clientSecret: String, username: String, apiKey: String, resource: String) {
        self.resource = resource
        super.init(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey)
    }
    
    override func processResponse(data: Data?, error: Error?, response: URLResponse?, completion: @escaping (Result<Data, APIError>) -> Void) {

        let url = Bundle.module.url(forResource: resource, withExtension: "json")
        let data = Data(contentsOf: url.path, encoding: .utf8)
        completion(.success("{\"hola\":\"DATA\"}".data(using: .utf8)!))
    }
}


final class VeryfiSDKTests: XCTestCase {

    
    func testGetDocuments() {
        
        if (mockResponses) {
            client = ClientSpy(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey, resource: "getDocuments.json")
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
        
        client.getDocuments(withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonDocuments = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let id = ((jsonDocuments?["documents"] as! NSArray)[0] as! NSDictionary)["id"] as! Int64
                client.getDocument(documentId: String(id), withCompletion: { result in
                    switch result {
                    case .success(let data):
                        let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                        let getDocumentId = jsonResponse?["id"] as! Int64
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
        
        wait(for: [expectation], timeout: 40.0)
    }
    
    func testProcessDocument() {
        
        let expectation = XCTestExpectation(description: "Get data from processing document")
        
        func getFile(fileName: String) -> [UInt8]? {
            let testCaseURL = URL(fileURLWithPath: "\(#file)", isDirectory: false)
            let testsFolderURL = testCaseURL.deletingLastPathComponent()
            let url = testsFolderURL.appendingPathComponent("\(fileName)", isDirectory: false)
            do {
                let data = try Data(contentsOf: url)
                return [UInt8](data)
            } catch {
                print("Not found: ", url)
                expectation.fulfill()
                return nil
            }
        }

        let fileName = file

        var fileData = Data()
        if let bytes: [UInt8] = getFile(fileName: fileName) {
            for byte in bytes {
                fileData.append(byte)
            }
        } else {
            print("File unreadable")
            expectation.fulfill()
        }
        
        let categories = ["Advertising & Marketing", "Automotive"]
        client.processDocument(fileName: file, fileData: fileData, categories: categories, deleteAfterProcessing: true, withCompletion: { result in
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
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testUpdateDocument() {
        
        func generateRandomString() -> String {
            
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<10).map{ _ in letters.randomElement()! })
        }
        
        let expectation = XCTestExpectation(description: "Get data from update document")
        
        let notes = generateRandomString()
        let updateNotes = ["notes": notes]
        
        client.getDocuments(withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonDocuments = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let id = ((jsonDocuments?["documents"] as! NSArray)[0] as! NSDictionary)["id"] as! Int64
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
        
        wait(for: [expectation], timeout: 40.0)
    }
    
    func testProcessDocumentURL() {
        
        let expectation = XCTestExpectation(description: "Get a JSON response from process document")
        
        let categories = ["Advertising & Marketing", "Automotive"]
        client.processDocumentURL(fileUrl: url, categories: categories, deleteAfterProcessing: true, boostMode: 1, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let vendor = (jsonResponse?["vendor"] as? NSDictionary)?["name"] as? String else {
                    XCTAssertTrue(false)
                    break
                }
                XCTAssertEqual("In-n-out Burger", vendor)
            case .failure(let error):
                print(error)
                XCTAssertTrue(false)
            }
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testDeleteDocument() {
        
        let expectationDocuments = XCTestExpectation(description: "Get documents")
        let expectationDelete = XCTestExpectation(description: "Get a JSON response from deleted document")
        
        client.processDocumentURL(fileUrl: url, withCompletion: { result in
            switch result {
            case .success(let data):
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let documentId = jsonResponse!["id"] as! Int64
                client.deleteDocument(documentId: String(documentId), withCompletion: { result in
                    switch result {
                    case .success(let data):
                        let jsonStringDeleteResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                        let status = jsonStringDeleteResponse!["status"] as! String
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
        
        wait(for: [expectationDocuments, expectationDelete], timeout: 40.0)
    }
    
    
    func testBadCredentials() {
        
        let expectation = XCTestExpectation(description: "Get response to a bad credential case")
        
        let badClient = Client(clientId: "badClientId", clientSecret: "badClientSecret", username: "badUsername", apiKey: "badApiKey")
        badClient.getDocuments(withCompletion: { result in
            switch result{
                case .success(let data):
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    let status = jsonResponse!["status"] as! String
                    let message = jsonResponse!["message"] as! String
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
