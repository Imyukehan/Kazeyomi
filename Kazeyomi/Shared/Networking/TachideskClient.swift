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
}
