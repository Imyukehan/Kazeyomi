import Foundation

struct PageInfo: Decodable, Hashable {
    let hasNextPage: Bool
    let hasPreviousPage: Bool
    let startCursor: String?
    let endCursor: String?
}
