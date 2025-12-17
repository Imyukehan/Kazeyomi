import Foundation
import Observation

@MainActor
@Observable
final class SourceSettingsViewModel {
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private(set) var displayName: String = ""
    private(set) var isConfigurable: Bool = false
    private(set) var preferences: [SourcePreferenceItem] = []

    func load(serverSettings: ServerSettingsStore, sourceID: String) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let payload = try await client.sourcePreferences(sourceID: sourceID)
            displayName = payload.displayName
            isConfigurable = payload.isConfigurable
            preferences = payload.preferences
        } catch {
            displayName = ""
            isConfigurable = false
            preferences = []
            errorMessage = error.localizedDescription
        }
    }

    func update(serverSettings: ServerSettingsStore, sourceID: String, change: TachideskAPI.SourcePreferenceChangeInput) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            try await client.updateSourcePreference(sourceID: sourceID, change: change)
            let payload = try await client.sourcePreferences(sourceID: sourceID)
            displayName = payload.displayName
            isConfigurable = payload.isConfigurable
            preferences = payload.preferences
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
