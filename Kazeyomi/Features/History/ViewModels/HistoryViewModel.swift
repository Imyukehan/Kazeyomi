import Foundation
import Observation

@MainActor
@Observable
final class HistoryViewModel {
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var items: [ChapterWithManga] = []

    func refresh(serverSettings: ServerSettingsStore) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            // Sorayomi does pagination + dedupe-by-manga; start with a single page.
            let page = try await client.readingHistory(pageSize: 200, offset: 0)

            // Keep only the most recent chapter per manga (Sorayomi behavior)
            var seen = Set<Int>()
            var unique: [ChapterWithManga] = []
            for item in page {
                if seen.contains(item.mangaId) { continue }
                seen.insert(item.mangaId)
                unique.append(item)
            }

            items = unique
        } catch {
            items = []
            errorMessage = error.localizedDescription
        }
    }

    func removeFromHistory(serverSettings: ServerSettingsStore, chapterID: Int) async {
        do {
            let client = TachideskClient(serverSettings: serverSettings)
            try await client.removeChapterFromHistory(chapterID: chapterID)
        } catch {
            // Keep UI responsive; surface error on next refresh.
        }
        await refresh(serverSettings: serverSettings)
    }
}
