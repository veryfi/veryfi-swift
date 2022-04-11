import Foundation

/// Base model used by the AddLineItem and UpdateLineItem models.
public class LineItem {
    var sku: String?
    var category: String?
    var tax: Float?
    var price: Float?
    var unitOfMeasure: String?
    var quantity: Float?
    var upc: String?
    var taxRate: Float?
    var discountRate: Float?
    var startDate: String?
    var endDate: String?
    var hsn: String?
    var section: String?
    var weight: String?
    
    init(){}
}
