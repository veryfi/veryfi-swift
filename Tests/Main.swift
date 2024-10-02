import XCTest
@testable import VeryfiSDKTests

XCTMain([
    testCase(VeryfiSDKTests.allTests)
])

extension VeryfiSDKTests {

    static var allTests : [(String, VeryfiSDKTests -> () throws -> Void)] {
        return [
            ("testGetDocuments", testGetDocuments),
            ("testGetDocument", testGetDocument),
            ("testProcessDocument", testProcessDocument),
            ("testProcessDocumentURL", testProcessDocumentURL),
            ("testGetAnyDocuments", testGetAnyDocuments),
            ("testGetAnyDocument", testGetAnyDocument),
            ("testProcessAnyDocument", testProcessAnyDocument),
            ("testProcessAnyDocumentURL", testProcessAnyDocumentURL),
            ("testGetBankStatements", testGetBankStatements),
            ("testGetBankStatement", testGetBankStatement),
            ("testProcessBankStatement" testProcessBankStatement),
            ("testProcessBankStatementURL", testProcessBankStatementURL),
            ("testAddTag", testAddTag),
            ("testAddTags", testAddTags),
            ("testUpdateDocument", testUpdateDocument),
            ("testDeleteDocument", testDeleteDocument),
            ("testGetDocumentLineItems", testGetDocumentLineItems)
            ("testGetLineItem", testGetLineItem)
            ("testAddLineItem", testAddLineItem)
            ("testUpdateLineItem", testUpdateLineItem)
            ("testDeleteDocumentLineItems", testDeleteDocumentLineItems)
            ("testDeleteLineItem", testDeleteLineItem)
            ("testBadCredentials", testBadCredentials)
        ]
    }
}
