import Foundation
import Observation

@MainActor
@Observable
final class SourceMangaListViewModel {
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var mangas: [Manga] = []

    private(set) var hasNextPage = false
    private var currentPage = 1

    func load(
        serverSettings: ServerSettingsStore,
        sourceID: String,
        type: TachideskAPI.FetchSourceMangaType = .popular
    ) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        currentPage = 1

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let page = try await client.fetchSourceManga(
                sourceID: sourceID,
                type: type,
                page: currentPage,
                query: nil
            )
            mangas = page.mangas
            hasNextPage = page.hasNextPage
        } catch {
            mangas = []
            hasNextPage = false
            errorMessage = error.localizedDescription
        }
    }

    func loadMore(
        serverSettings: ServerSettingsStore,
        sourceID: String,
        type: TachideskAPI.FetchSourceMangaType = .popular
    ) async {
        guard !isLoading, hasNextPage else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let nextPageNumber = currentPage + 1
            let page = try await client.fetchSourceManga(
                sourceID: sourceID,
                type: type,
                page: nextPageNumber,
                query: nil
            )
            currentPage = nextPageNumber
            mangas.append(contentsOf: page.mangas)
            hasNextPage = page.hasNextPage
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
