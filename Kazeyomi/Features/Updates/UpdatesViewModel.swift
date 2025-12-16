import Foundation
import Observation

@MainActor
@Observable
final class UpdatesViewModel {
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var items: [ChapterWithManga] = []
    private(set) var canLoadMore = true

    private var pageNo: Int = 0

    func refresh(serverSettings: ServerSettingsStore) async {
        pageNo = 0
        items = []
        canLoadMore = true
        await loadMore(serverSettings: serverSettings)
    }

    func loadMore(serverSettings: ServerSettingsStore) async {
        guard !isLoading else { return }
        guard canLoadMore else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let page = try await client.recentChaptersPage(pageNo: pageNo)

            if page.isEmpty {
                canLoadMore = false
                return
            }

            items.append(contentsOf: page)
            pageNo += 1
            // Conservative: stop when fewer than 30 returned (Sorayomi offset stride)
            canLoadMore = page.count >= 30
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
