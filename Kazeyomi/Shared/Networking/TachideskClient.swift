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
}
