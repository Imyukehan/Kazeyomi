import Apollo
import Foundation

struct AboutServerPayload: Hashable {
    let buildTime: String
    let name: String
    let version: String
    let revision: String
    let buildType: String
    let github: String
    let discord: String
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

struct SourceMangaPage: Hashable {
    let hasNextPage: Bool
    let mangas: [Manga]
}

struct SourcePreferencesPayload: Hashable {
    let sourceID: String
    let displayName: String
    let isConfigurable: Bool
    let preferences: [SourcePreferenceItem]
}

enum ExtensionUpdateAction {
    case install
    case uninstall
    case update
}

enum TachideskClientError: LocalizedError {
    case graphQLErrors([String])
    case missingData

    var errorDescription: String? {
        switch self {
        case .graphQLErrors(let messages):
            return messages.first
        case .missingData:
            return String(localized: "error.graphql.missing_data")
        }
    }
}

final class TachideskClient {
    private static let defaultCategoryID = 0

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

            throw TachideskClientError.graphQLErrors(
                messages.isEmpty ? [String(localized: "error.graphql.request_failed")] : messages
            )
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

    private func mapSourcePreferences(_ preferences: [TachideskAPI.SourcePreferencesQuery.Data.Source.Preference]) -> [SourcePreferenceItem] {
        preferences.enumerated().compactMap { index, preference in
            if let p = preference.asCheckBoxPreference {
                guard p.visible else { return nil }
                return .checkBox(
                    position: index,
                    key: p.key,
                    title: p.checkBoxTitle,
                    summary: p.summary,
                    value: p.checkBoxValue ?? p.checkBoxDefaultValue,
                    defaultValue: p.checkBoxDefaultValue
                )
            }

            if let p = preference.asSwitchPreference {
                guard p.visible else { return nil }
                return .toggle(
                    position: index,
                    key: p.key,
                    title: p.switchTitle,
                    summary: p.summary,
                    value: p.switchValue ?? p.switchDefaultValue,
                    defaultValue: p.switchDefaultValue
                )
            }

            if let p = preference.asListPreference {
                guard p.visible else { return nil }
                let title = p.listTitle ?? p.key
                let defaultValue = p.listDefaultValue
                let value = p.listValue ?? defaultValue ?? p.entryValues.first ?? ""
                return .list(
                    position: index,
                    key: p.key,
                    title: title,
                    summary: p.summary,
                    value: value,
                    defaultValue: defaultValue,
                    entries: p.entries,
                    entryValues: p.entryValues
                )
            }

            if let p = preference.asEditTextPreference {
                guard p.visible else { return nil }
                let title = p.editTextTitle ?? p.key
                let defaultValue = p.editTextDefaultValue
                let value = p.editTextValue ?? defaultValue ?? ""
                return .editText(
                    position: index,
                    key: p.key,
                    title: title,
                    summary: p.summary,
                    value: value,
                    defaultValue: defaultValue,
                    dialogTitle: p.dialogTitle,
                    dialogMessage: p.dialogMessage
                )
            }

            if let p = preference.asMultiSelectListPreference {
                guard p.visible else { return nil }
                let title = p.multiSelectTitle ?? p.key
                let defaultValues = p.multiSelectDefaultValue ?? []
                let values = p.multiSelectValue ?? defaultValues
                return .multiSelect(
                    position: index,
                    key: p.key,
                    title: title,
                    summary: p.summary,
                    values: values,
                    defaultValues: defaultValues,
                    entries: p.entries,
                    entryValues: p.entryValues,
                    dialogTitle: p.dialogTitle,
                    dialogMessage: p.dialogMessage
                )
            }

            return nil
        }
    }

    func aboutServer() async throws -> AboutServerPayload {
        let client = try makeApolloClient()
        let result = try await client.fetchAsync(query: TachideskAPI.AboutServerQuery())
        let data = try requireData(result)

        let about = data.aboutServer
        return AboutServerPayload(
            buildTime: about.buildTime,
            name: about.name,
            version: about.version,
            revision: about.revision,
            buildType: about.buildType,
            github: about.github,
            discord: about.discord
        )
    }

    func allCategories(first: Int = 200, offset: Int = 0) async throws -> [Category] {
        let client = try makeApolloClient()
        let result = try await client.fetchAsync(
            query: TachideskAPI.AllCategoriesQuery(first: first, offset: offset),
            cachePolicy: .fetchIgnoringCacheCompletely
        )
        let data = try requireData(result)

        return data.categories.nodes.map { node in
            Category(id: node.id, name: node.name, order: node.order, isDefault: node.default)
        }
    }

    func categoryMangas(categoryID: Int) async throws -> [Manga] {
        let client = try makeApolloClient()
        let result = try await client.fetchAsync(
            query: TachideskAPI.CategoryMangasQuery(categoryId: categoryID),
            cachePolicy: .fetchIgnoringCacheCompletely
        )
        let data = try requireData(result)

        let mangas = data.category.mangas.nodes.map { node in
            Manga(
                id: node.id,
                title: node.title,
                thumbnailUrl: node.thumbnailUrl,
                inLibrary: node.inLibrary,
                sourceId: node.sourceId
            )
        }

        var seenIDs = Set<Int>()
        return mangas
            .filter { $0.inLibrary }
            .filter { seenIDs.insert($0.id).inserted }
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

    func extensions(first: Int = 500, offset: Int = 0) async throws -> [ExtensionPackage] {
        let client = try makeApolloClient()
        let result = try await client.fetchAsync(query: TachideskAPI.ExtensionsQuery(first: first, offset: offset))
        let data = try requireData(result)

        return data.extensions.nodes.map { node in
            ExtensionPackage(
                pkgName: node.pkgName,
                name: node.name,
                lang: node.lang,
                versionName: node.versionName,
                versionCode: node.versionCode,
                iconUrl: node.iconUrl,
                isInstalled: node.isInstalled,
                hasUpdate: node.hasUpdate,
                isObsolete: node.isObsolete,
                isNsfw: node.isNsfw,
                repo: node.repo,
                apkName: node.apkName
            )
        }
    }

    func fetchExtensions() async throws -> [ExtensionPackage] {
        let client = try makeApolloClient()
        let result = try await client.performAsync(mutation: TachideskAPI.FetchExtensionsMutation())
        let data = try requireData(result)

        guard let payload = data.fetchExtensions else { return [] }
        return payload.extensions.map { ext in
            ExtensionPackage(
                pkgName: ext.pkgName,
                name: ext.name,
                lang: ext.lang,
                versionName: ext.versionName,
                versionCode: ext.versionCode,
                iconUrl: ext.iconUrl,
                isInstalled: ext.isInstalled,
                hasUpdate: ext.hasUpdate,
                isObsolete: ext.isObsolete,
                isNsfw: ext.isNsfw,
                repo: ext.repo,
                apkName: ext.apkName
            )
        }
    }

    func updateExtension(pkgName: String, action: ExtensionUpdateAction) async throws -> ExtensionPackage? {
        let client = try makeApolloClient()

        let patch: TachideskAPI.UpdateExtensionPatchInput
        switch action {
        case .install:
            patch = TachideskAPI.UpdateExtensionPatchInput(install: true)
        case .uninstall:
            patch = TachideskAPI.UpdateExtensionPatchInput(uninstall: true)
        case .update:
            patch = TachideskAPI.UpdateExtensionPatchInput(update: true)
        }

        let result = try await client.performAsync(
            mutation: TachideskAPI.UpdateExtensionMutation(id: pkgName, patch: patch)
        )
        let data = try requireData(result)

        guard let ext = data.updateExtension?.extension else { return nil }
        return ExtensionPackage(
            pkgName: ext.pkgName,
            name: ext.name,
            lang: ext.lang,
            versionName: ext.versionName,
            versionCode: ext.versionCode,
            iconUrl: ext.iconUrl,
            isInstalled: ext.isInstalled,
            hasUpdate: ext.hasUpdate,
            isObsolete: ext.isObsolete,
            isNsfw: ext.isNsfw,
            repo: ext.repo,
            apkName: ext.apkName
        )
    }

    func sourcePreferences(sourceID: String) async throws -> SourcePreferencesPayload {
        let client = try makeApolloClient()
        let result = try await client.fetchAsync(query: TachideskAPI.SourcePreferencesQuery(sourceId: sourceID))
        let data = try requireData(result)

        let source = data.source
        return SourcePreferencesPayload(
            sourceID: source.id,
            displayName: source.displayName,
            isConfigurable: source.isConfigurable,
            preferences: mapSourcePreferences(source.preferences)
        )
    }

    func updateSourcePreference(sourceID: String, change: TachideskAPI.SourcePreferenceChangeInput) async throws {
        let client = try makeApolloClient()
        let result = try await client.performAsync(
            mutation: TachideskAPI.UpdateSourcePreferenceMutation(sourceId: sourceID, change: change)
        )
        let data = try requireData(result)
        guard data.updateSourcePreference != nil else {
            throw TachideskClientError.missingData
        }
    }

    func fetchSourceManga(
        sourceID: String,
        type: TachideskAPI.FetchSourceMangaType,
        page: Int,
        query: String?
    ) async throws -> SourceMangaPage {
        let client = try makeApolloClient()
        let input = TachideskAPI.FetchSourceMangaInput(
            filters: nil,
            page: page,
            query: query.map { .some($0) } ?? nil,
            source: sourceID,
            type: .init(type)
        )

        let result = try await client.performAsync(
            mutation: TachideskAPI.FetchSourceMangaMutation(input: input)
        )
        let data = try requireData(result)

        guard let payload = data.fetchSourceManga else {
            throw TachideskClientError.missingData
        }
        let mangas = payload.mangas.map { node in
            Manga(
                id: node.id,
                title: node.title,
                thumbnailUrl: node.thumbnailUrl,
                inLibrary: node.inLibrary,
                sourceId: node.sourceId
            )
        }

        return SourceMangaPage(hasNextPage: payload.hasNextPage, mangas: mangas)
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
                    unreadCount: node.manga.unreadCount,
                    inLibrary: nil
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
                    unreadCount: node.manga.unreadCount,
                    inLibrary: node.manga.inLibrary
                )
            )
        }
    }

    func removeChapterFromHistory(chapterID: Int) async throws {
        let client = try makeApolloClient()
        let result = try await client.performAsync(mutation: TachideskAPI.RemoveFromHistoryMutation(chapterId: chapterID))
        _ = try requireData(result)
    }

    func mangaDetail(id: Int, chaptersFirst: Int = 200, chaptersOffset: Int = 0) async throws -> (MangaDetail, [MangaChapter]) {
        let client = try makeApolloClient()
        let result = try await client.fetchAsync(
            query: TachideskAPI.MangaDetailQuery(
                id: id,
                chaptersFirst: chaptersFirst,
                chaptersOffset: chaptersOffset
            )
        )
        let data = try requireData(result)

        let manga = data.manga
        let categories = manga.categories.nodes.map { node in
            Category(id: node.id, name: node.name, order: node.order, isDefault: node.default)
        }
        let detail = MangaDetail(
            id: manga.id,
            title: manga.title,
            thumbnailUrl: manga.thumbnailUrl,
            author: manga.author,
            artist: manga.artist,
            description: manga.description,
            status: rawValue(manga.status),
            genres: manga.genre,
            url: manga.url,
            realUrl: manga.realUrl,
            categories: categories,
            unreadCount: manga.unreadCount,
            inLibrary: manga.inLibrary
        )

        let chapters = data.chapters.nodes.map { node in
            MangaChapter(
                id: node.id,
                name: node.name,
                chapterNumber: node.chapterNumber,
                scanlator: node.scanlator,
                isRead: node.isRead,
                isDownloaded: node.isDownloaded,
                uploadDate: node.uploadDate
            )
        }

        return (detail, chapters)
    }

    func updateMangaInLibrary(mangaID: Int, inLibrary: Bool) async throws -> Bool {
        let client = try makeApolloClient()
        let result = try await client.performAsync(
            mutation: TachideskAPI.UpdateMangaMutation(
                id: mangaID,
                patch: TachideskAPI.UpdateMangaPatchInput(inLibrary: .some(inLibrary))
            )
        )
        let data = try requireData(result)

        guard let payload = data.updateManga else {
            throw TachideskClientError.missingData
        }

        return payload.manga.inLibrary
    }

    func setMangaCategories(mangaID: Int, categoryIDs: [Int], currentCategoryIDs: [Int]) async throws -> [Category] {
        let client = try makeApolloClient()

        // WebUI behavior:
        // - The "Default" category is a special server category with id == 0.
        // - It is hidden from the UI and not explicitly added/removed.
        // - Category changes are done via add/remove diff over NON-default categories.
        let desiredNonDefault = Set(categoryIDs).subtracting([Self.defaultCategoryID])
        let currentNonDefault = Set(currentCategoryIDs).subtracting([Self.defaultCategoryID])

        let addSet = desiredNonDefault.subtracting(currentNonDefault)
        let removeSet = currentNonDefault.subtracting(desiredNonDefault)

        let patch = TachideskAPI.UpdateMangaCategoriesPatchInput(
            addToCategories: addSet.isEmpty ? nil : .some(Array(addSet).sorted()),
            removeFromCategories: removeSet.isEmpty ? nil : .some(Array(removeSet).sorted())
        )

        let result = try await client.performAsync(
            mutation: TachideskAPI.UpdateMangaCategoriesMutation(
                id: mangaID,
                patch: patch
            )
        )
        let data = try requireData(result)

        guard let payload = data.updateMangaCategories else {
            throw TachideskClientError.missingData
        }

        return payload.manga.categories.nodes.map { node in
            Category(id: node.id, name: node.name, order: node.order, isDefault: node.default)
        }
    }

    func fetchChapters(mangaID: Int) async throws {
        let client = try makeApolloClient()
        let result = try await client.performAsync(mutation: TachideskAPI.FetchChaptersMutation(mangaId: mangaID))
        let data = try requireData(result)

        guard data.fetchChapters != nil else {
            throw TachideskClientError.missingData
        }
    }

    func fetchChapterPages(chapterID: Int) async throws -> [String] {
        let client = try makeApolloClient()
        let result = try await client.performAsync(mutation: TachideskAPI.FetchChapterPagesMutation(chapterId: chapterID))
        let data = try requireData(result)

        guard let payload = data.fetchChapterPages else {
            throw TachideskClientError.missingData
        }

        return payload.pages
    }
}
