import Foundation
import Observation

@MainActor
@Observable
final class CategoryMangaListViewModel {
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var mangas: [Manga] = []

    func load(serverSettings: ServerSettingsStore, categoryID: Int) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let result = try await client.categoryMangas(categoryID: categoryID)

            // Installed source IDs (used to hide legacy entries after source migration).
            let installedSourceIDs: Set<String>
            do {
                let sources = try await client.sources(first: 500, offset: 0)
                installedSourceIDs = Set(sources.map { $0.id })
            } catch {
                installedSourceIDs = []
            }

            // 1) Ensure stable uniqueness for SwiftUI (ForEach ids must be unique).
            var seenIDs = Set<Int>()
            let uniqueByID = result
                .filter { !shouldHideAsLegacy($0) }
                .filter { seenIDs.insert($0.id).inserted }

            // 2) Handle common migration/legacy scenario: same title appears twice, and one entry
            //    is missing cover (often from an uninstalled/expired source). Prefer the one
            //    with a thumbnail.
            func normalizedTitle(_ value: String) -> String {
                value
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .lowercased()
            }

            func hasThumbnail(_ manga: Manga) -> Bool {
                guard let url = manga.thumbnailUrl else { return false }
                return !url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }

            func shouldHideAsLegacy(_ manga: Manga) -> Bool {
                // If we can't determine installed sources, don't hide based on this heuristic.
                guard !installedSourceIDs.isEmpty else { return false }

                // If the source isn't installed, treat the entry as an "unknown source" manga.
                // These usually come from removed/expired extensions; hide them in library lists.
                return !installedSourceIDs.contains(manga.sourceId)
            }

            var firstIndexByTitle: [String: Int] = [:]
            var output: [Manga] = []
            output.reserveCapacity(uniqueByID.count)

            for manga in uniqueByID {
                let key = normalizedTitle(manga.title)
                if let existingIndex = firstIndexByTitle[key] {
                    let existing = output[existingIndex]
                    let existingHasThumb = hasThumbnail(existing)
                    let currentHasThumb = hasThumbnail(manga)

                    if !existingHasThumb && currentHasThumb {
                        output[existingIndex] = manga
                    } else if existingHasThumb && !currentHasThumb {
                        continue
                    } else {
                        // Ambiguous (both have/none have thumbnail): keep both.
                        output.append(manga)
                    }
                } else {
                    firstIndexByTitle[key] = output.count
                    output.append(manga)
                }
            }

            mangas = output
        } catch {
            mangas = []
            errorMessage = error.localizedDescription
        }
    }
}
