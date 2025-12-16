import Foundation

struct MangaBase: Identifiable, Decodable, Hashable {
    let id: Int
    let title: String
    let thumbnailUrl: String?
    let unreadCount: Int?
}
