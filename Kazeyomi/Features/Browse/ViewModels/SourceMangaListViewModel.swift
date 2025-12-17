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
    private var currentType: TachideskAPI.FetchSourceMangaType = .popular
    private var currentQuery: String?

    func load(
        serverSettings: ServerSettingsStore,
        sourceID: String,
        type: TachideskAPI.FetchSourceMangaType = .popular,
        query: String? = nil
    ) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        currentPage = 1
        currentType = type
        currentQuery = query

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let page = try await client.fetchSourceManga(
                sourceID: sourceID,
                type: type,
                page: currentPage,
                query: query
            )
            mangas = page.mangas
            hasNextPage = page.hasNextPage
        } catch {
            mangas = []
            hasNextPage = false
            errorMessage = error.localizedDescription
        }
    }

    func reload(serverSettings: ServerSettingsStore, sourceID: String) async {
        await load(
            serverSettings: serverSettings,
            sourceID: sourceID,
            type: currentType,
            query: currentQuery
        )
    }

    func search(serverSettings: ServerSettingsStore, sourceID: String, query: String) async {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if q.isEmpty {
            await load(serverSettings: serverSettings, sourceID: sourceID, type: .popular, query: nil)
            return
        }
        await load(serverSettings: serverSettings, sourceID: sourceID, type: .search, query: q)
    }

    func loadMore(
        serverSettings: ServerSettingsStore,
        sourceID: String,
        type: TachideskAPI.FetchSourceMangaType = .popular,
        query: String? = nil
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
                query: query
            )
            currentPage = nextPageNumber
            mangas.append(contentsOf: page.mangas)
            hasNextPage = page.hasNextPage
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadMoreCurrent(serverSettings: ServerSettingsStore, sourceID: String) async {
        await loadMore(
            serverSettings: serverSettings,
            sourceID: sourceID,
            type: currentType,
            query: currentQuery
        )
    }
}
