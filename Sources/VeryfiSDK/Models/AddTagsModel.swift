//
//  File.swift
//  
//
//  Created by Veryfi on 28/09/24.
//

import Foundation

public class AddTags: Encodable {
    var tags: [String]
    init(tags: [String]) {
        self.tags = tags
    }
}
