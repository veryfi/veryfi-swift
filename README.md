
<img src="https://user-images.githubusercontent.com/30441118/212185646-f96d2e4c-daf4-4286-8f1b-c92058224b87.png#gh-dark-mode-only" width="200">
<img src="https://user-images.githubusercontent.com/30441118/212185644-ab61c399-0f0c-4d22-a361-0191632d63d2.png#gh-light-mode-only" width="200">

![Swift 5.3](https://img.shields.io/badge/Swift-5.3-orange.svg?style=flat)
[![code coverage](.github/metrics/code_coverage.svg)](.github/metrics/code_coverage.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

## Installation
Install from Swift Package Manager, using this repository as the url.

## Getting Started

### Obtaining Client ID and user keys
If you don't have an account with Veryfi, please go ahead and register here: [https://hub.veryfi.com/signup/api/](https://hub.veryfi.com/signup/api/).

### Veryfi Swift Client Library
The **veryfi** library can be used to communicate with Veryfi API. All available functionality is described [here](https://veryfi.github.io/veryfi-swift/documentation/veryfisdk/).

Below is the sample Swift code using **veryfi** to OCR and extract data from a document:

#### Process a document
```swift
import UIKit
import VeryfiSDK

class ViewController: UIViewController {
    
    let clientId = "your_client_id"
    let clientSecret = "your_client_secret"
    let username = "your_username"
    let apiKey = "your_password"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let client = Client(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey)
        let file = "receipt"
        let url = Bundle(for: Self.self).url(forResource: file, withExtension: "jpeg")!
        let fileData = try? Data(contentsOf: url)
        client.processDocument(fileName: file, fileData: fileData!) { result in
            switch result {
            case .success(let data):
                print("Succeded")
            case .failure(let error):
                print("Error")
            }
        }
    }
}
```

#### Update a document
```swift
import UIKit
import VeryfiSDK

class ViewController: UIViewController {
    
    let clientId = "your_client_id"
    let clientSecret = "your_client_secret"
    let username = "your_username"
    let apiKey = "your_password"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let client = Client(clientId: clientId, clientSecret: clientSecret, username: username, apiKey: apiKey)
        let documentId = "your_document_id"
        var parameters = [String : Any]()
        parameters["category"] = "Meals & Entertainment"
        parameters["total"] =  11.23
        client.updateDocument(documentId: documentId, params: parameters) { result in
            switch result {
            case .success(let data):
                print("Succeded")
            case .failure(let error):
                print("Error")
            }
        }
    }
}
```

## Release
1. Create new branch for your code
2. Change version in `Constants.swift`
3. Commit changes and push to Github
4. Create PR pointing to master branch and add a Veryfi member as a reviewer
5. Tag your commit with the new version
6. The new version will be accesible through Swift Package Manager

## Need help?
If you run into any issue or need help installing or using the library, please contact support@veryfi.com.

If you found a bug in this library or would like new features added, then open an issue or pull requests against this repo!

To learn more about Veryfi visit https://www.veryfi.com/
