import Foundation
import Observation

@MainActor
@Observable
final class UpdatesViewModel {
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var lastUpdateTimestamp: String?

    func load(serverSettings: ServerSettingsStore) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            lastUpdateTimestamp = try await client.lastUpdateTimestamp()
        } catch {
            lastUpdateTimestamp = nil
            errorMessage = error.localizedDescription
        }
    }
}
