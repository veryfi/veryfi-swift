//
//  veryfi_swiftTests.swift
//  veryfi-swiftTests
//
//  Created by Matt Eng on 7/27/21.
//

import XCTest
@testable import veryfi_swift
import veryfi_swift

let client_id = ""
let client_secret = ""
let username = ""
let api_key = ""
var my_client: Client  = Client(client_id: "", client_secret: "", username: "", api_key: "")

class veryfi_swiftTests: XCTestCase {

    override func setUpWithError() throws {
        my_client = Client(client_id: client_id, client_secret: client_secret, username: username, api_key: api_key)
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() throws {
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        throw XCTSkip("Skipped.")
//
//        my_client.get_documents(withCompletion: { detail, error in
//            if error != nil {
//                //handle error
//            } else if detail == detail {
//                //You can use detail here
//                guard let prettyPrintedJson = String(data: detail!, encoding: .utf8) else {
//                    print("Error: Couldn't print JSON in String")
//                    return
//                }
////                print(prettyPrintedJson)
//            }
//        })
////        XCTAssert()
//    }
//
    func testGetDocument() throws {
        throw XCTSkip("Skipped.")

        my_client.get_document(doc_id: "37825037", withCompletion: { detail, error in
            if error != nil {
                //handle error
            } else if detail == detail {
                //You can use detail here
                guard let prettyPrintedJson = String(data: detail!, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                print(prettyPrintedJson)
            }
        })
    }
    
    func testTryDocument() throws {
//        throw XCTSkip("Skipped.")
        
        my_client.update_document(doc_id: "37825037", withCompletion: { detail, error in //params: ["date":"2016-01-20 00:00:00"], withCompletion: { detail, error in
            if error != nil {
//                print(error)
            } else if detail == detail {
                guard let prettyPrintedJson = String(data: detail!, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                print(prettyPrintedJson)
            }
        })
    }
    
//    func testDeleteDocument() throws {
//        throw XCTSkip("Skipped.")
//
////        my_client.delete_document(doc_id: "37825037", withCompletion: { detail, error in
////            if error != nil {
////                //handle error
////            } else if detail == detail {
////                //You can use detail here
////                guard let prettyPrintedJson = String(data: detail!, encoding: .utf8) else {
////                    print("Error: Couldn't print JSON in String")
////                    return
////                }
//////                print(prettyPrintedJson)
////            }
////        })
//    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
