//
//  veryfi_errorTests.swift
//  veryfi-errorTests
//
//  Created by Matt Eng on 7/30/21.
//

import XCTest
@testable import veryfi_swift
import veryfi_swift

@available(macOS 12.0.0, *)
class veryfi_errorTests: XCTestCase {

    override func setUpWithError() throws {
        client = Client(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey)
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    func badAuthenticationGetDocumentsThrowsRuntimeError() async throws {
        let badClient = Client(clientId: "", clientSecret: "", username: "", apiKey: "")
        do {
            _ = try await badClient.getDocuments()
            XCTFail("Expected to throw but succeeded")
        } catch {
            XCTAssert(true) //Temporary until can assert errors
        }
    }

    func testGetDocumentWithBadDocumentId() async throws {
//        let expectation = XCTestExpectation(description: "Get data from update document")
        let documentId = "00000000"
        do {
            _ = try await client.getDocument(documentId: documentId)
            XCTFail("Expected to throw but succeeded")
        } catch {
            XCTAssert(true) //Temporary until can assert errors
        }
    }
    
    func testUpdateDocumentInvalidParameterThrowsRuntimeError() async throws {
        let documentId = "38583124"
        let params = ["invalid parameter":"2016-01-20 00:00:00"]
        do {
            _ = try await client.updateDocument(documentId: documentId, params: params)
            XCTFail("Expected to throw but succeeded")
        } catch {
            XCTAssert(true) //Temporary until can assert errors
        }
    }
    
    func testUpdateDocumentInvalidDocumentThrowsRuntimeError() async throws {
        let documentId = "00000000"
        let params = ["date":"2016-01-20 00:00:00"]
        do {
            _ = try await client.updateDocument(documentId: documentId, params: params)
            XCTFail("Expected to throw but succeeded")
        } catch {
            XCTAssert(true) //Temporary until can assert errors
        }
    }
    
    func testDeleteDocumentWithInvalidDocument() async throws {
        do {
            _ = try await client.deleteDocument(documentId: "00000000")
            XCTFail("Expected to throw but succeeded")
        } catch {
            XCTAssert(true) //Temporary until can assert errors
        }
    }
    
    func testProcessDocumentWithMissingDocument() async throws {
        let expectation = XCTestExpectation(description: "Throw runtime error with nonexistent document")
        
        let fileData = Data()
        
        do {
            _ = try await client.processDocument(fileName: "invalid document name", fileData: fileData)
            XCTFail("Expected to throw but succeeded")
        } catch {
            XCTAssert(true) //Temporary until can assert errors
        }
    }
    
    func testProcessDocumentUrlWithInvalidUrl() async throws {
        let expectation = XCTestExpectation(description: "Throw runtime error when given invalid url to access.")
        
        do {
            _ = try await client.processDocumentURL(fileUrls: ["https://invalid-url-to-a-website-throw-error.com"])
            XCTFail("Expected to throw but succeeded")
        } catch {
            XCTAssert(true) //Temporary until can assert errors
        }
    }

    func skip_testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
