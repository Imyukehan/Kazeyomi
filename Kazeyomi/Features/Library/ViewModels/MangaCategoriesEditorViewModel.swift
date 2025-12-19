import Foundation
import Observation

@MainActor
@Observable
final class MangaCategoriesEditorViewModel {
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
            categories = try await client.allCategories()
        } catch {
            categories = []
            errorMessage = error.localizedDescription
        }
    }
}
