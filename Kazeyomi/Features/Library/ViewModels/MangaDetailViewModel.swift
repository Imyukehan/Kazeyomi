import Foundation
import Observation

@MainActor
@Observable
final class MangaDetailViewModel {
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private(set) var manga: MangaDetail?
    private(set) var chapters: [MangaChapter] = []

    func load(serverSettings: ServerSettingsStore, mangaID: Int) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let (detail, list) = try await client.mangaDetail(id: mangaID)
            manga = detail
            chapters = list
        } catch {
            manga = nil
            chapters = []
            errorMessage = error.localizedDescription
        }
    }
}
