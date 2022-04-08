//
//  Extensions.swift
//  
//
//  Created by Sebastian Giraldo on 8/04/22.
//

import Foundation
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
