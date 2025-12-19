import Foundation
import Observation

@MainActor
@Observable
final class BrowseExtensionsViewModel {
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var extensions: [ExtensionPackage] = []
    private(set) var activePkgNames: Set<String> = []

    func load(serverSettings: ServerSettingsStore) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            extensions = try await client.extensions()
        } catch {
            extensions = []
            errorMessage = error.localizedDescription
        }
    }

    func refreshRemote(serverSettings: ServerSettingsStore) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            _ = try await client.fetchExtensions()
            extensions = try await client.extensions()
        } catch {
            extensions = []
            errorMessage = error.localizedDescription
        }
    }

    func perform(_ action: ExtensionUpdateAction, pkgName: String, serverSettings: ServerSettingsStore) async {
        guard !activePkgNames.contains(pkgName) else { return }
        activePkgNames.insert(pkgName)
        defer { activePkgNames.remove(pkgName) }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let updated = try await client.updateExtension(pkgName: pkgName, action: action)

            if let updated {
                if let idx = extensions.firstIndex(where: { $0.pkgName == pkgName }) {
                    extensions[idx] = updated
                } else {
                    extensions.insert(updated, at: 0)
                }
            } else {
                extensions = try await client.extensions()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func isActive(pkgName: String) -> Bool {
        activePkgNames.contains(pkgName)
    }
}
