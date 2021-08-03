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
        do {
            let (resData,_) = try await client.getDocument(documentId: documentId)
            let jsonObject = try JSONSerialization.jsonObject(with: resData) as? [String: Any]
            XCTAssert("\(jsonObject!["id"]!)" == documentId)
        } catch {
            XCTAssert(false)
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
        XCTAssert((res as! HTTPURLResponse).statusCode < 300)
        for (k,v) in params {
            XCTAssert(jsonObject[k] as! String == v)
        }
    }
    
    func skip_testDeleteDocument() async throws {
        let (resData,_) = try await client.deleteDocument(documentId: "37825037")
        guard let jsonObject = try JSONSerialization.jsonObject(with: resData) as? [String: Any] else { //force unwrapping data
            print("Error: Cannot convert data to JSON object")
            return
        }
        XCTAssert("\(jsonObject["status"]!)" == "good")
    }
    
    func testProcessDocument() async throws {
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
        }
        
        //Make the request
        do {
            let (resData,_) = try await client.processDocument(fileName: fileName, fileData: fileData)
            
            guard let jsonObject = try JSONSerialization.jsonObject(with: resData) as? [String: Any] else {
                print("Error: Cannot convert data to JSON object")
                return
            }
            print(jsonObject)
        } catch {
            print(error)
        }
    }
    
    func testProcessDocumentUrl() async throws {
        let (resData,_) = try await client.processDocumentURL(fileUrls: ["https://discuss.poynt.net/uploads/default/original/2X/6/60c4199364474569561cba359d486e6c69ae8cba.jpeg"])
        guard let jsonObject = try JSONSerialization.jsonObject(with: resData) as? [String: Any] else { //force unwrapping data
            print("Error: Cannot convert data to JSON object")
            return
        }
        print(jsonObject)
    }

    func skip_testPerformance() throws {
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
