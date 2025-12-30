import Foundation
import Observation

@MainActor
@Observable
final class LibraryViewModel {
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var categories: [Category] = []

    func load(serverSettings: ServerSettingsStore) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let result = try await client.allCategories()

            // Determine installed sources once (used to hide legacy entries after source migration).
            // If this fails, fall back to showing categories based on raw server data.
            let installedSourceIDs: Set<String>
            do {
                let sources = try await client.sources(first: 500, offset: 0)
                installedSourceIDs = Set(sources.map { $0.id })
            } catch {
                installedSourceIDs = []
            }

            // Hide categories that are confirmed empty (including Default when it has no manga).
            // If we fail to determine emptiness (network error), keep the category to avoid hiding data.
            let nonEmpty = await withTaskGroup(of: Category?.self) { group in
                for category in result {
                    group.addTask {
                        do {
                            let mangas = try await client.categoryMangas(categoryID: category.id)

                            // If we know installed sources, treat "unknown source" manga as hidden.
                            // This prevents showing a category that will look empty in the UI.
                            let visibleMangas: [Manga]
                            if installedSourceIDs.isEmpty {
                                visibleMangas = mangas
                            } else {
                                visibleMangas = mangas.filter { installedSourceIDs.contains($0.sourceId) }
                            }

                            return visibleMangas.isEmpty ? nil : category
                        } catch {
                            return category
                        }
                    }
                }

                var kept: [Category] = []
                for await value in group {
                    if let value {
                        kept.append(value)
                    }
                }

                // Preserve original ordering from server response.
                let keptIDs = Set(kept.map { $0.id })
                return result.filter { keptIDs.contains($0.id) }
            }

            categories = nonEmpty
        } catch {
            categories = []
            errorMessage = error.localizedDescription
        }
    }
}
