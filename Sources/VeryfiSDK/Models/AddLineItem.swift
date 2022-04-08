import Foundation

public class AddLineItem: LineItem, Encodable {
    var order: Int
    var description: String
    var total: Float
    init(order: Int, description: String, total: Float) {
        self.order = order
        self.description = description
        self.total = total
    }
}
