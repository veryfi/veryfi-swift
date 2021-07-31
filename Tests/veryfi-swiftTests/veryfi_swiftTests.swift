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
    }

    func testGetAllDocuments() async throws {
        let (resData,res) = try await client.getDocuments()
        guard let jsonObject = try JSONSerialization.jsonObject(with: resData) as? [[String: Any]] else { //force unwrapping data
            print("Error: Cannot convert data to JSON object")
            return
        }
        XCTAssert((res as! HTTPURLResponse).statusCode < 300)
        for json in jsonObject {
            XCTAssert(json["id"] != nil)
        }
    }

    func testGetDocument() async throws {
        let documentId = "38583124"
        let (resData,res) = try await client.getDocument(documentId: documentId)
        guard let jsonObject = try JSONSerialization.jsonObject(with: resData) as? [String: Any] else { //force unwrapping data
            print("Error: Cannot convert data to JSON object")
            return
        }
        let status = (res as! HTTPURLResponse).statusCode
        XCTAssert(status < 300)
        if status != 400 {
            XCTAssert("\(jsonObject["id"]!)" == "\(documentId)")
        }
    }
    
    func testUpdateDocument() async throws {
        let documentId = "38583124"
        let params = ["date":"2016-01-20 00:00:00"]
        let (resData,res) = try await client.updateDocument(documentId: documentId, params: params)
        guard let jsonObject = try JSONSerialization.jsonObject(with: resData) as? [String: Any] else { //force unwrapping data
            print("Error: Cannot convert data to JSON object")
            return
        }
//        print(jsonObject)
        XCTAssert((res as! HTTPURLResponse).statusCode < 300)
        for (k,v) in params {
            XCTAssert(jsonObject[k] as! String == v)
        }
    }
    
    func skip_testDeleteDocument() async throws {
        let (resData,res) = try await client.deleteDocument(documentId: "37825037")
        guard let jsonObject = try JSONSerialization.jsonObject(with: resData) as? [String: Any] else { //force unwrapping data
            print("Error: Cannot convert data to JSON object")
            return
        }
        XCTAssert("\(jsonObject["status"]!)" == "good")
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
