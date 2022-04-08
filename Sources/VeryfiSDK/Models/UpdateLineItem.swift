import Foundation

public class UpdateLineItem: LineItem, Encodable  {
    var order: Int?
    var description: String?
    var total: Float?
}
