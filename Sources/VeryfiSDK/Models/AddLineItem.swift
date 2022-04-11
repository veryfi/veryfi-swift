import Foundation

/// Model used to create a line item on the Veryfi API.
public class AddLineItem: LineItem, Encodable {
    var order: Int
    var description: String
    var total: Float
    
    /// Init AddLineItem model with required arguments.
    /// - Parameters:
    ///   - order: Lineitem order
    ///   - description: Lineitem description
    ///   - total: Lineitem total.
    init(order: Int, description: String, total: Float) {
        self.order = order
        self.description = description
        self.total = total
    }
}
