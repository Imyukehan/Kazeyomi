import Foundation

struct AboutServerPayload: Decodable {
    let name: String
    let version: String
    let revision: String
    let buildType: String
}

struct AboutServerQueryData: Decodable {
    let aboutServer: AboutServerPayload
}

struct LastUpdateTimestampPayload: Decodable {
    let timestamp: String
}

struct LastUpdateTimestampQueryData: Decodable {
    let lastUpdateTimestamp: LastUpdateTimestampPayload
}

struct DownloadQueueItem: Decodable {
    let state: String
    let progress: Double
    let position: Int
}

struct DownloadStatusPayload: Decodable {
    let queue: [DownloadQueueItem]
    let state: String
}

struct DownloadStatusQueryData: Decodable {
    let downloadStatus: DownloadStatusPayload
}

struct SourcesQueryData: Decodable {
    struct SourcesPayload: Decodable {
        let nodes: [Source]
    }

    let sources: SourcesPayload
}

struct ChapterNodeListPayload<Node: Decodable>: Decodable {
    let nodes: [Node]
    let pageInfo: PageInfo
    let totalCount: Int
}

struct RecentChaptersQueryData: Decodable {
    let chapters: ChapterNodeListPayload<ChapterWithManga>
}

struct ReadingHistoryQueryData: Decodable {
    let chapters: ChapterNodeListPayload<ChapterWithManga>
}

struct UpdateChapterMutationData: Decodable {
    struct UpdateChapterPayload: Decodable {
        struct ChapterPayload: Decodable {
            let id: Int
        }

        let chapter: ChapterPayload
    }

    let updateChapter: UpdateChapterPayload?
}

final class TachideskClient {
    private let graphQL: GraphQLClient
    private let serverSettings: ServerSettingsStore

    init(graphQL: GraphQLClient = GraphQLClient(), serverSettings: ServerSettingsStore) {
        self.graphQL = graphQL
        self.serverSettings = serverSettings
    }

    func aboutServer() async throws -> AboutServerPayload {
        let endpoint = try serverSettings.graphQLEndpointURL()
        let data: AboutServerQueryData = try await graphQL.execute(
            endpoint: endpoint,
            query: """
            query AboutServer {
              aboutServer {
                name
                version
                revision
                buildType
              }
            }
            """,
            authorization: serverSettings.authorizationHeaderValue
        )
        return data.aboutServer
    }

        func allCategories(first: Int = 200, offset: Int = 0) async throws -> [Category] {
                struct CategoriesPayload: Decodable {
                        let nodes: [Category]
                }
                struct CategoriesQueryData: Decodable {
                        let categories: CategoriesPayload
                }

                let endpoint = try serverSettings.graphQLEndpointURL()
                let data: CategoriesQueryData = try await graphQL.execute(
                        endpoint: endpoint,
                        query: """
                        query AllCategories {
                            categories(first: \(first), orderBy: ORDER, orderByType: ASC, offset: \(offset)) {
                                nodes {
                                    id
                                    name
                                    order
                                    default
                                }
                            }
                        }
                        """,
                        authorization: serverSettings.authorizationHeaderValue
                )
                return data.categories.nodes
        }

        func categoryMangas(categoryID: Int) async throws -> [Manga] {
                struct MangaPayload: Decodable {
                        let nodes: [Manga]
                }
                struct CategoryPayload: Decodable {
                        let mangas: MangaPayload
                }
                struct CategoryMangasQueryData: Decodable {
                        let category: CategoryPayload
                }

                let endpoint = try serverSettings.graphQLEndpointURL()
                let data: CategoryMangasQueryData = try await graphQL.execute(
                        endpoint: endpoint,
                        query: """
                        query GetCategoryMangas {
                            category(id: \(categoryID)) {
                                mangas {
                                    nodes {
                                        id
                                        title
                                        thumbnailUrl
                                    }
                                }
                            }
                        }
                        """,
                        authorization: serverSettings.authorizationHeaderValue
                )
                return data.category.mangas.nodes
        }

        func lastUpdateTimestamp() async throws -> String {
                let endpoint = try serverSettings.graphQLEndpointURL()
                let data: LastUpdateTimestampQueryData = try await graphQL.execute(
                        endpoint: endpoint,
                        query: """
                        query LastUpdateTimestamp {
                            lastUpdateTimestamp {
                                timestamp
                            }
                        }
                        """,
                        authorization: serverSettings.authorizationHeaderValue
                )
                return data.lastUpdateTimestamp.timestamp
        }

        func downloadStatus() async throws -> DownloadStatusPayload {
                let endpoint = try serverSettings.graphQLEndpointURL()
                let data: DownloadStatusQueryData = try await graphQL.execute(
                        endpoint: endpoint,
                        query: """
                        query DownloadStatus {
                            downloadStatus {
                                state
                                queue {
                                    position
                                    progress
                                    state
                                }
                            }
                        }
                        """,
                        authorization: serverSettings.authorizationHeaderValue
                )
                return data.downloadStatus
        }

        func sources(first: Int = 500, offset: Int = 0) async throws -> [Source] {
                let endpoint = try serverSettings.graphQLEndpointURL()
                let data: SourcesQueryData = try await graphQL.execute(
                        endpoint: endpoint,
                        query: """
                        query Sources {
                            sources(first: \(first), offset: \(offset), orderBy: NAME, orderByType: ASC) {
                                nodes {
                                    id
                                    name
                                    displayName
                                    lang
                                    iconUrl
                                    isNsfw
                                    supportsLatest
                                }
                            }
                        }
                        """,
                        authorization: serverSettings.authorizationHeaderValue
                )
                return data.sources.nodes
        }

        /// Sorayomi's "Updates" screen: fetch chapters ordered by fetchedAt desc.
        func recentChaptersPage(pageNo: Int) async throws -> [ChapterWithManga] {
                let endpoint = try serverSettings.graphQLEndpointURL()
                let offset = pageNo * 30
                let data: RecentChaptersQueryData = try await graphQL.execute(
                        endpoint: endpoint,
                        query: """
                        query GetChapterWithMangaPage {
                            chapters(
                                first: 50,
                                offset: \(offset),
                                filter: { inLibrary: { equalTo: true } },
                                order: [
                                    { by: FETCHED_AT, byType: DESC },
                                    { by: SOURCE_ORDER, byType: DESC }
                                ]
                            ) {
                                nodes {
                                    id
                                    name
                                    mangaId
                                    fetchedAt
                                    isRead
                                    lastPageRead
                                    isDownloaded
                                    scanlator
                                    manga {
                                        id
                                        title
                                        thumbnailUrl
                                        unreadCount
                                    }
                                }
                                pageInfo {
                                    hasNextPage
                                    hasPreviousPage
                                    startCursor
                                    endCursor
                                }
                                totalCount
                            }
                        }
                        """,
                        authorization: serverSettings.authorizationHeaderValue
                )
                return data.chapters.nodes
        }

        /// Sorayomi's "History" screen: chapters with reading progress, ordered by lastReadAt desc.
        func readingHistory(pageSize: Int, offset: Int) async throws -> [ChapterWithManga] {
                let endpoint = try serverSettings.graphQLEndpointURL()
                let data: ReadingHistoryQueryData = try await graphQL.execute(
                        endpoint: endpoint,
                        query: """
                        query GetReadingHistory {
                            chapters(
                                first: \(pageSize),
                                offset: \(offset),
                                filter: {
                                    inLibrary: { equalTo: true },
                                    lastReadAt: { isNull: false, greaterThan: "0" },
                                    or: [
                                        { isRead: { equalTo: true } },
                                        { lastPageRead: { greaterThan: 0 } }
                                    ]
                                },
                                order: [
                                    { by: LAST_READ_AT, byType: DESC },
                                    { by: SOURCE_ORDER, byType: DESC }
                                ]
                            ) {
                                nodes {
                                    id
                                    name
                                    mangaId
                                    lastReadAt
                                    isRead
                                    lastPageRead
                                    isDownloaded
                                    scanlator
                                    manga {
                                        id
                                        title
                                        thumbnailUrl
                                        unreadCount
                                    }
                                }
                                pageInfo {
                                    hasNextPage
                                    hasPreviousPage
                                    startCursor
                                    endCursor
                                }
                                totalCount
                            }
                        }
                        """,
                        authorization: serverSettings.authorizationHeaderValue
                )
                return data.chapters.nodes
        }

        func removeChapterFromHistory(chapterID: Int) async throws {
                let endpoint = try serverSettings.graphQLEndpointURL()
                _ = try await graphQL.execute(
                        endpoint: endpoint,
                        query: """
                        mutation RemoveFromHistory {
                            updateChapter(input: { id: \(chapterID), patch: { isRead: false, lastPageRead: 0 } }) {
                                chapter { id }
                            }
                        }
                        """,
                        authorization: serverSettings.authorizationHeaderValue
                ) as UpdateChapterMutationData
        }
}
