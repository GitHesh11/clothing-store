
import Foundation

struct Product: Identifiable, Hashable, Encodable, Decodable {
    var id: String
    var name: String
    var category: String
    var description: String
    var type: String
    var color : String
    var size: String
    var price: Double
    var imageURL: String
    var quantity: Int
}
