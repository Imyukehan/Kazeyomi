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

            // Hide categories that are confirmed empty (e.g. Default often is).
            // If we fail to determine emptiness (network error), keep the category to avoid hiding data.
            let nonEmpty = await withTaskGroup(of: Category?.self) { group in
                for category in result {
                    group.addTask {
                        do {
                            let mangas = try await client.categoryMangas(categoryID: category.id)
                            return mangas.isEmpty ? nil : category
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
