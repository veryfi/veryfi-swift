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
@available(macOS 12.0.0, *)
var client: Client  = Client(clientId: "", clientSecret: "", username: "", apiKey: "")

@available(macOS 12.0.0, *)
class veryfi_swiftTests: XCTestCase {

    override func setUpWithError() throws {
        client = Client(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey)
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetAllDocuments() async throws {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        let expectation = XCTestExpectation(description: "Get data from update document")
        let (resData,res) = try await client.getDocuments()
        guard let jsonObject = try JSONSerialization.jsonObject(with: resData) as? [String: Any] else { //force unwrapping data
            print("Error: Cannot convert data to JSON object")
            return
        }
        print(jsonObject)
//        wait(for: [expectation], timeout: 20.0)
//        XCTAssert()
    }

    func testGetDocument() async throws {
//        let expectation = XCTestExpectation(description: "Get data from update document")
        let (resData,res) = try await client.getDocument(documentId: "38583124")
        guard let jsonObject = try JSONSerialization.jsonObject(with: resData) as? [String: Any] else { //force unwrapping data
            print("Error: Cannot convert data to JSON object")
            return
        }
        print(jsonObject)
//        , withCompletion: { detail, error in
//            if error != nil { //Handle error
//            } else if detail == detail {
//                //You can use detail here
//                guard let prettyPrintedJson = String(data: detail!, encoding: .utf8) else {
//                    print("Error: Couldn't print JSON in String")
//                    return
//                }
//                expectation.fulfill()
//                print(prettyPrintedJson)
//            }
//        })
//        wait(for: [expectation], timeout: 20.0)
    }
    
    func testUpdateDocument() async throws {
//        let expectation = XCTestExpectation(description: "Get data from update document")
        
        let (resData,res) = try await client.updateDocument(documentId: "38583124", params: ["date":"2016-01-20 00:00:00"])
        guard let jsonObject = try JSONSerialization.jsonObject(with: resData) as? [String: Any] else { //force unwrapping data
            print("Error: Cannot convert data to JSON object")
            return
        }
        print(jsonObject)
//                              , withCompletion: { detail, error in
//            XCTAssertNotNil(detail, "No data was downloaded.")
//            if error != nil {
//                print(error)
//                expectation.fulfill()
//            } else if detail == detail {
//                guard let prettyPrintedJson = String(data: detail!, encoding: .utf8) else {
//                    print("Error: Couldn't print JSON in String")
//                    return
//                }
//                print(prettyPrintedJson)
//                expectation.fulfill()
//            }
//        })
//        wait(for: [expectation], timeout: 20.0)
    }
    
    func skip_testDeleteDocument() async throws {
//        let expectation = XCTestExpectation(description: "Delete document")
        
        let (resData,res) = try await client.deleteDocument(documentId: "37825037")
//        , withCompletion: { detail, error in
//            if error != nil {
//                print(error)
//                expectation.fulfill()
//            } else if detail == detail {
//                //You can use detail here
//                guard let prettyPrintedJson = String(data: detail!, encoding: .utf8) else {
//                    print("Error: Couldn't print JSON in String")
//                    return
//                }
//                print(prettyPrintedJson)
//                expectation.fulfill()
//            }
//        })
//        wait(for: [expectation], timeout: 20.0)
    }
    
    func testProcessDocument() async throws {
        let expectation = XCTestExpectation(description: "Get data from processing document")
        
        /// Retrieve and encode file.
        /// - Parameter fileName: Full name of file.
        /// - Returns: UInt8 encoded file data.
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
        
        let fileName = "receipt.png"
        var fileData = Data()
        if let bytes: [UInt8] = getFile(fileName: fileName) {
            for byte in bytes {
                fileData.append(byte)
            }
        } else {
            print("File unreadable")
            expectation.fulfill()
        }
        
        //Make the request
        let (resData,res) = try await client.processDocument(fileName: fileName, fileData: fileData)
        guard (res as? HTTPURLResponse)!.statusCode < 300 else {throw Client.MyError.runtimeError(res)}
        
        guard let jsonObject = try JSONSerialization.jsonObject(with: resData) as? [String: Any] else { //force unwrapping data
            print("Error: Cannot convert data to JSON object")
            return
        }
        print(jsonObject)
        expectation.fulfill()
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testProcessDocumentUrl() async throws {
        let expectation = XCTestExpectation(description: "POST file url and return response")
        
        let (resData,res) = try await client.processDocumentURL(fileUrls: ["https://discuss.poynt.net/uploads/default/original/2X/6/60c4199364474569561cba359d486e6c69ae8cba.jpeg"])
        guard let jsonObject = try JSONSerialization.jsonObject(with: resData) as? [String: Any] else { //force unwrapping data
            print("Error: Cannot convert data to JSON object")
            return
        }
        print(jsonObject)
        expectation.fulfill()
        wait(for: [expectation], timeout: 20.0)
    }

    func skip_testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
