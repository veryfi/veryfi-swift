//
//  UpdateLineItem.swift
//  
//
//  Created by Sebastian Giraldo on 8/04/22.
//

import Foundation

public class UpdateLineItem: LineItem, Encodable  {
    var order: Int?
    var description: String?
    var total: Float?
}
