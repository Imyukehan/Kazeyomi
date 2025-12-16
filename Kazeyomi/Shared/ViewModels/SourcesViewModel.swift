import Foundation
import Observation

@MainActor
@Observable
final class SourcesViewModel {
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var sources: [Source] = []

    func load(serverSettings: ServerSettingsStore) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            sources = try await client.sources()
        } catch {
            sources = []
            errorMessage = error.localizedDescription
        }
    }
}
