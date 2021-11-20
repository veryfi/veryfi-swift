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
            ("testUpdateDocument", testUpdateDocument),
            ("testProcessDocumentURL", testProcessDocumentURL),
            ("testDeleteDocument", testDeleteDocument),
            ("testBadCredentials", testBadCredentials)
        ]
    }
}
