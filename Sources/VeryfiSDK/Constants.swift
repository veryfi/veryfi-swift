//
//  Constants.swift
//  
//
//  Created by Diego Giraldo Gómez on 3/11/21.
//

import Foundation

struct Constants {
    static let baseUrl = "https://api.veryfi.com/api/"
    static let apiVersion = "v7"
    
    static var url: String {
        return self.baseUrl + self.apiVersion
    }
}
