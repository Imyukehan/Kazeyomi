import Foundation
import Observation

@MainActor
@Observable
final class ReaderViewModel {
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private(set) var pages: [String] = []

    func load(serverSettings: ServerSettingsStore, chapterID: Int) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            pages = try await client.fetchChapterPages(chapterID: chapterID)
        } catch {
            pages = []
            errorMessage = error.localizedDescription
        }
    }
}
