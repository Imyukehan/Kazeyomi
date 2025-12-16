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
            mangas = result
        } catch {
            mangas = []
            errorMessage = error.localizedDescription
        }
    }
}
