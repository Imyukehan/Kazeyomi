import Foundation

struct ChapterWithManga: Identifiable, Decodable, Hashable {
    let id: Int

    let name: String?
    let mangaId: Int

    let fetchedAt: String?
    let lastReadAt: String?

    let isRead: Bool?
    let lastPageRead: Int?
    let isDownloaded: Bool?

    let scanlator: String?

    let manga: MangaBase
}
