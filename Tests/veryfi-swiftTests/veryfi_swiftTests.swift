//
//  veryfi_swiftTests.swift
//  veryfi-swiftTests
//
//  Created by Matt Eng on 7/27/21.
//

import XCTest
@testable import veryfi_swift
import veryfi_swift

let clientId = ""
let clientSecret = ""
let username = ""
let apiKey = ""
var client: Client  = Client(clientId: "", clientSecret: "", username: "", apiKey: "")

class veryfi_swiftTests: XCTestCase {

    override func setUpWithError() throws {
        client = Client(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey)
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func skip_testGetAllDocuments() throws {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Get data from update document")
        client.getDocuments(withCompletion: { detail, error in
            if error != nil {
                //handle error
            } else if detail == detail {
                //You can use detail here
                guard let prettyPrintedJson = String(data: detail!, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
//                print(prettyPrintedJson)
                expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: 20.0)
//        XCTAssert()
    }

    func skip_testGetDocument() throws {
        let expectation = XCTestExpectation(description: "Get data from update document")
        client.getDocument(documentId: "37825037", withCompletion: { detail, error in
            if error != nil { //Handle error
            } else if detail == detail {
                //You can use detail here
                guard let prettyPrintedJson = String(data: detail!, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                expectation.fulfill()
                print(prettyPrintedJson)
            }
        })
        wait(for: [expectation], timeout: 20.0)
    }
    
    func skip_testUpdateDocument() throws {
        let expectation = XCTestExpectation(description: "Get data from update document")
        
        client.updateDocument(documentId: "37825037", params: ["date":"2016-01-20 00:00:00"], withCompletion: { detail, error in
            XCTAssertNotNil(detail, "No data was downloaded.")
            if error != nil {
                print(error)
                expectation.fulfill()
            } else if detail == detail {
                guard let prettyPrintedJson = String(data: detail!, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                print(prettyPrintedJson)
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 20.0)
    }
    
    func skip_testDeleteDocument() throws {
        let expectation = XCTestExpectation(description: "Delete document")
        
        client.deleteDocument(documentId: "37825037", withCompletion: { detail, error in
            if error != nil {
                print(error)
                expectation.fulfill()
            } else if detail == detail {
                //You can use detail here
                guard let prettyPrintedJson = String(data: detail!, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                print(prettyPrintedJson)
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testProcessDocument() throws {
        let expectation = XCTestExpectation(description: "Get data from processing document")
        
        client.processDocument(fileName: "receipt.png", withCompletion: { detail, error in
            if error != nil {
                print(error)
                expectation.fulfill()
                return
            } else if detail != nil {
                //You can use detail here
                let prettyPrintedJson = String(data: detail!, encoding: .utf8)!
                print(prettyPrintedJson)
                expectation.fulfill()
                return
            }
            print("Error: Couldn't print JSON in String")
            expectation.fulfill()
            return
        })
        wait(for: [expectation], timeout: 20.0)
    }
    
    func skip_testProcessDocumentUrl() throws {
        let expectation = XCTestExpectation(description: "POST file url and return response")
        
        client.processDocumentURL(fileUrls: ["https://discuss.poynt.net/uploads/default/original/2X/6/60c4199364474569561cba359d486e6c69ae8cba.jpeg"], withCompletion: { detail, error in
            if error != nil {
                print("ERROR IN OUTPUT")
                print(error)
                expectation.fulfill()
            } else if detail == detail {
                guard let prettyPrintedJson = String(data: detail!, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                print(prettyPrintedJson)
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 20.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
