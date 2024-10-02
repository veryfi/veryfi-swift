//
//  File.swift
//  
//
//  Created by Veryfi on 28/09/24.
//

import Foundation

public class AddTag: Encodable {
    var name: String
    init(name: String) {
        self.name = name
    }
}
