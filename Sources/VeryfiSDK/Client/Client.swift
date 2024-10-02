import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct VeryfiCredentials {
    let clientId: String
    let clientSecret: String
    let username: String
    let apiKey: String
}

public class Client: NetworkManager {
    
    /// Init Client.
    /// - Parameters:
    ///   - clientId: Your client id from veryfi-hub.
    ///   - clientSecret: Your client secret from veryfi-hub.
    ///   - username: Your username from veryfi-hub.
    ///   - apiKey: Your api key from veryfi-hub.
    ///   - apiVersion: Api version to use, by default "v8".
    public init(clientId: String, clientSecret: String, username: String, apiKey: String, apiVersion: String = "v8") {
        let credentials = VeryfiCredentials(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey)
        super.init(credentials: credentials, apiVersion: apiVersion)
    }
}
