import Foundation
import Observation

@MainActor
@Observable
final class MangaDetailViewModel {
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private(set) var isUpdatingLibrary = false
    private(set) var isUpdatingCategories = false

    private(set) var manga: MangaDetail?
    private(set) var chapters: [MangaChapter] = []

    var browserURLString: String? {
        guard let manga else { return nil }
        return manga.realUrl ?? manga.url
    }

    func load(serverSettings: ServerSettingsStore, mangaID: Int, forceFetchChapters: Bool = false) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let (detail, list) = try await client.mangaDetail(id: mangaID)
            manga = detail
            chapters = list

            if forceFetchChapters || list.isEmpty {
                do {
                    try await client.fetchChapters(mangaID: mangaID)
                    let (refreshedDetail, refreshedList) = try await client.mangaDetail(id: mangaID)
                    manga = refreshedDetail
                    chapters = refreshedList
                } catch {
                    // Keep the already-loaded detail, but surface the fetch error.
                    errorMessage = error.localizedDescription
                }
            }
        } catch {
            manga = nil
            chapters = []
            errorMessage = error.localizedDescription
        }
    }

    func toggleInLibrary(serverSettings: ServerSettingsStore, mangaID: Int) async {
        guard !isUpdatingLibrary else { return }
        guard let current = manga?.inLibrary else { return }

        let newValue = !current
        manga?.inLibrary = newValue

        isUpdatingLibrary = true
        errorMessage = nil
        defer { isUpdatingLibrary = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let serverValue = try await client.updateMangaInLibrary(mangaID: mangaID, inLibrary: newValue)
            manga?.inLibrary = serverValue
        } catch {
            manga?.inLibrary = current
            errorMessage = error.localizedDescription
        }
    }

    func addToLibrary(serverSettings: ServerSettingsStore, mangaID: Int, categoryIDs: [Int]) async {
        guard !isUpdatingLibrary && !isUpdatingCategories else { return }
        guard manga != nil else { return }

        let previousInLibrary = manga?.inLibrary ?? false
        let previousCategories = manga?.categories ?? []

        manga?.inLibrary = true

        isUpdatingLibrary = true
        isUpdatingCategories = true
        errorMessage = nil
        defer {
            isUpdatingLibrary = false
            isUpdatingCategories = false
        }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            _ = try await client.updateMangaInLibrary(mangaID: mangaID, inLibrary: true)

            // Refresh current categories after inLibrary toggle to capture any server-side
            // default category assignment, then apply the category diff update.
            let (refreshedDetail, _) = try await client.mangaDetail(id: mangaID, chaptersFirst: 1, chaptersOffset: 0)
            manga?.categories = refreshedDetail.categories

            let categories = try await client.setMangaCategories(
                mangaID: mangaID,
                categoryIDs: categoryIDs,
                currentCategoryIDs: refreshedDetail.categories.map(\.id)
            )
            manga?.categories = categories
        } catch {
            manga?.inLibrary = previousInLibrary
            manga?.categories = previousCategories
            errorMessage = error.localizedDescription
        }
    }

    func updateCategories(serverSettings: ServerSettingsStore, mangaID: Int, categoryIDs: [Int]) async {
        guard !isUpdatingCategories else { return }

        isUpdatingCategories = true
        errorMessage = nil
        defer { isUpdatingCategories = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let categories = try await client.setMangaCategories(
                mangaID: mangaID,
                categoryIDs: categoryIDs,
                currentCategoryIDs: manga?.categories.map(\.id) ?? []
            )
            manga?.categories = categories
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
