import Foundation

struct Category: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let order: Int
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case order
        case isDefault = "default"
    }
}
