import Foundation

struct Manga: Identifiable, Decodable, Hashable {
    let id: Int
    let title: String
    let thumbnailUrl: String?
    let inLibrary: Bool
    let sourceId: String
}
