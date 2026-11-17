import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import VeryfiSDK

/// Records the JSON body of every request instead of sending it.
final class RequestRecorder: Client {
    private(set) var bodies: [[String: Any]] = []

    override func request(method: VeryfiSDK.Method,
                          route: Endpoint,
                          queryItems: [URLQueryItem]?,
                          uploadData: Data?,
                          body: Data?,
                          queryItem: String?,
                          completion: @escaping (Result<Data, APIError>) -> Void) {
        if let payload = uploadData ?? body,
           let json = try? JSONSerialization.jsonObject(with: payload) as? [String: Any] {
            bodies.append(json)
        }
        completion(.success(Data("{}".utf8)))
    }
}

extension VeryfiSDKTests {
    private func receiptData() -> Data {
        let url = Bundle.module.url(forResource: "receipt", withExtension: "jpeg")!
        return try! Data(contentsOf: url)
    }

    func testProcessDocumentThinking() {
        for mode in [ThinkingMode.light, ThinkingMode.deep] {
            let recorder = RequestRecorder(clientId: clientId, username: username, apiKey: apiKey)
            recorder.processDocument(fileName: file, fileData: receiptData(), thinking: mode, withCompletion: { _ in })

            XCTAssertEqual(recorder.bodies.count, 1)
            XCTAssertEqual(recorder.bodies.first?["thinking"] as? String, mode.rawValue)
        }
    }

    func testProcessDocumentWithoutThinking() {
        let recorder = RequestRecorder(clientId: clientId, username: username, apiKey: apiKey)
        recorder.processDocument(fileName: file, fileData: receiptData(), withCompletion: { _ in })

        XCTAssertEqual(recorder.bodies.count, 1)
        XCTAssertNil(recorder.bodies.first?["thinking"])
    }

    func testProcessDocumentURLThinking() {
        for mode in [ThinkingMode.light, ThinkingMode.deep] {
            let recorder = RequestRecorder(clientId: clientId, username: username, apiKey: apiKey)
            recorder.processDocumentURL(fileUrl: url, thinking: mode, withCompletion: { _ in })

            XCTAssertEqual(recorder.bodies.count, 1)
            XCTAssertEqual(recorder.bodies.first?["thinking"] as? String, mode.rawValue)
        }
    }

    func testProcessDocumentURLWithoutThinking() {
        let recorder = RequestRecorder(clientId: clientId, username: username, apiKey: apiKey)
        recorder.processDocumentURL(fileUrl: url, withCompletion: { _ in })

        XCTAssertEqual(recorder.bodies.count, 1)
        XCTAssertNil(recorder.bodies.first?["thinking"])
    }
}
