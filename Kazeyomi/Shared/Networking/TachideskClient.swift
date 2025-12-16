import Apollo
import Foundation

struct AboutServerPayload: Hashable {
    let name: String
    let version: String
    let revision: String
    let buildType: String
}

struct DownloadQueueItem: Hashable {
    let state: String
    let progress: Double
    let position: Int
}

struct DownloadStatusPayload: Hashable {
    let queue: [DownloadQueueItem]
    let state: String
}

enum TachideskClientError: LocalizedError {
    case graphQLErrors([String])
    case missingData

    var errorDescription: String? {
        switch self {
        case .graphQLErrors(let messages):
            return messages.first
        case .missingData:
            return "GraphQL 响应缺少 data"
        }
    }
}

final class TachideskClient {
    private let serverSettings: ServerSettingsStore
    private let clientFactory: TachideskApolloClientFactory

    init(
        serverSettings: ServerSettingsStore,
        clientFactory: TachideskApolloClientFactory = TachideskApolloClientFactory()
    ) {
        self.serverSettings = serverSettings
        self.clientFactory = clientFactory
    }

    private func makeApolloClient() throws -> ApolloClient {
        let endpoint = try serverSettings.graphQLEndpointURL()
        return clientFactory.makeClient(
            endpointURL: endpoint,
            authorization: serverSettings.authorizationHeaderValue
        )
    }

    private func requireData<Data>(_ result: GraphQLResult<Data>) throws -> Data {
        if let errors = result.errors, !errors.isEmpty {
            let messages = errors
                .compactMap { $0.message as String? }
                .filter { !$0.isEmpty }

            throw TachideskClientError.graphQLErrors(messages.isEmpty ? ["GraphQL 请求失败"] : messages)
        }
        guard let data = result.data else {
            throw TachideskClientError.missingData
        }
        return data
    }

    private func rawValue<E: RawRepresentable>(_ value: GraphQLEnum<E>) -> String where E.RawValue == String {
        // Apollo iOS uses `GraphQLEnum` to preserve unknown enum cases.
        // Prefer raw string value to keep UI logic (e.g. "QUEUED") stable.
        // Some Apollo versions expose `rawValue` as `String`, others as `String?`.
        return (value.rawValue as String?) ?? "UNKNOWN"
    }

    func aboutServer() async throws -> AboutServerPayload {
        let client = try makeApolloClient()
        let result = try await client.fetchAsync(query: TachideskAPI.AboutServerQuery())
        let data = try requireData(result)

        let about = data.aboutServer
        return AboutServerPayload(
            name: about.name,
            version: about.version,
            revision: about.revision,
            buildType: about.buildType
        )
    }

    func allCategories(first: Int = 200, offset: Int = 0) async throws -> [Category] {
        let client = try makeApolloClient()
        let result = try await client.fetchAsync(query: TachideskAPI.AllCategoriesQuery(first: first, offset: offset))
        let data = try requireData(result)

        return data.categories.nodes.map { node in
            Category(id: node.id, name: node.name, order: node.order, isDefault: node.default)
        }
    }

    func categoryMangas(categoryID: Int) async throws -> [Manga] {
        let client = try makeApolloClient()
        let result = try await client.fetchAsync(query: TachideskAPI.CategoryMangasQuery(categoryId: categoryID))
        let data = try requireData(result)

        return data.category.mangas.nodes.map { node in
            Manga(id: node.id, title: node.title, thumbnailUrl: node.thumbnailUrl)
        }
    }

    func lastUpdateTimestamp() async throws -> String {
        let client = try makeApolloClient()
        let result = try await client.fetchAsync(query: TachideskAPI.LastUpdateTimestampQuery())
        let data = try requireData(result)
        return data.lastUpdateTimestamp.timestamp
    }

    func downloadStatus() async throws -> DownloadStatusPayload {
        let client = try makeApolloClient()
        let result = try await client.fetchAsync(query: TachideskAPI.DownloadStatusQuery())
        let data = try requireData(result)

        let payload = data.downloadStatus
        return DownloadStatusPayload(
            queue: payload.queue.map { item in
                DownloadQueueItem(
                    state: rawValue(item.state),
                    progress: item.progress,
                    position: item.position
                )
            },
            state: rawValue(payload.state)
        )
    }

    func sources(first: Int = 500, offset: Int = 0) async throws -> [Source] {
        let client = try makeApolloClient()
        let result = try await client.fetchAsync(query: TachideskAPI.SourcesQuery(first: first, offset: offset))
        let data = try requireData(result)

        return data.sources.nodes.map { node in
            Source(
                id: node.id,
                name: node.name,
                displayName: node.displayName,
                lang: node.lang,
                iconUrl: node.iconUrl,
                isNsfw: node.isNsfw,
                supportsLatest: node.supportsLatest
            )
        }
    }

    /// Sorayomi's "Updates" screen: fetch chapters ordered by fetchedAt desc.
    func recentChaptersPage(pageNo: Int) async throws -> [ChapterWithManga] {
        let client = try makeApolloClient()
        let offset = pageNo * 30

        let result = try await client.fetchAsync(query: TachideskAPI.RecentChaptersPageQuery(first: 50, offset: offset))
        let data = try requireData(result)

        return data.chapters.nodes.map { node in
            ChapterWithManga(
                id: node.id,
                name: node.name,
                mangaId: node.mangaId,
                fetchedAt: node.fetchedAt,
                lastReadAt: nil,
                isRead: node.isRead,
                lastPageRead: node.lastPageRead,
                isDownloaded: node.isDownloaded,
                scanlator: node.scanlator,
                manga: MangaBase(
                    id: node.manga.id,
                    title: node.manga.title,
                    thumbnailUrl: node.manga.thumbnailUrl,
                    unreadCount: node.manga.unreadCount
                )
            )
        }
    }

    /// Sorayomi's "History" screen: chapters with reading progress, ordered by lastReadAt desc.
    func readingHistory(pageSize: Int, offset: Int) async throws -> [ChapterWithManga] {
        let client = try makeApolloClient()
        let result = try await client.fetchAsync(query: TachideskAPI.ReadingHistoryQuery(first: pageSize, offset: offset))
        let data = try requireData(result)

        return data.chapters.nodes.map { node in
            ChapterWithManga(
                id: node.id,
                name: node.name,
                mangaId: node.mangaId,
                fetchedAt: nil,
                lastReadAt: node.lastReadAt,
                isRead: node.isRead,
                lastPageRead: node.lastPageRead,
                isDownloaded: node.isDownloaded,
                scanlator: node.scanlator,
                manga: MangaBase(
                    id: node.manga.id,
                    title: node.manga.title,
                    thumbnailUrl: node.manga.thumbnailUrl,
                    unreadCount: node.manga.unreadCount
                )
            )
        }
    }

    func removeChapterFromHistory(chapterID: Int) async throws {
        let client = try makeApolloClient()
        let result = try await client.performAsync(mutation: TachideskAPI.RemoveFromHistoryMutation(chapterId: chapterID))
        _ = try requireData(result)
    }
}
