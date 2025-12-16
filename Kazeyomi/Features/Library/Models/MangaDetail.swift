import Foundation

struct MangaDetail: Identifiable, Hashable {
    let id: Int
    let title: String
    let thumbnailUrl: String?

    let author: String?
    let artist: String?
    let description: String?

    /// Raw GraphQL enum value (e.g. "ONGOING").
    let status: String
    let genres: [String]

    let unreadCount: Int
    let inLibrary: Bool
}

struct MangaChapter: Identifiable, Hashable {
    let id: Int
    let name: String
    let chapterNumber: Double
    let scanlator: String?

    let isRead: Bool
    let isDownloaded: Bool
    let uploadDate: String
}
