import Apollo
internal import Dispatch

extension ApolloClient {
    func fetchAsync<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .fetchIgnoringCacheCompletely
    ) async throws -> GraphQLResult<Query.Data> {
        try await withCheckedThrowingContinuation { continuation in
            _ = fetch(query: query, cachePolicy: cachePolicy, queue: .global(qos: .userInitiated)) { result in
                continuation.resume(with: result)
            }
        }
    }

    func performAsync<Mutation: GraphQLMutation>(
        mutation: Mutation,
        publishResultToStore: Bool = true
    ) async throws -> GraphQLResult<Mutation.Data> {
        try await withCheckedThrowingContinuation { continuation in
            _ = perform(
                mutation: mutation,
                publishResultToStore: publishResultToStore,
                queue: .global(qos: .userInitiated)
            ) { result in
                continuation.resume(with: result)
            }
        }
    }
}
