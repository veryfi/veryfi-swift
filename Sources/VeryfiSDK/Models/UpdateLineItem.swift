import Foundation

/// Model used to update a line item on the Veryfi API.
public class UpdateLineItem: LineItem, Encodable  {
    var order: Int?
    var description: String?
    var total: Float?
}
