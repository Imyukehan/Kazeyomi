import Apollo
import Foundation

final class TachideskApolloClientFactory {
    private let store: ApolloStore

    init(store: ApolloStore = ApolloStore(cache: InMemoryNormalizedCache())) {
        self.store = store
    }

    func makeClient(endpointURL: URL, authorization: String?) -> ApolloClient {
        var headers: [String: String] = [:]
        if let authorization {
            headers["Authorization"] = authorization
        }

        let interceptorProvider = DefaultInterceptorProvider(store: store)
        let transport = RequestChainNetworkTransport(
            interceptorProvider: interceptorProvider,
            endpointURL: endpointURL,
            additionalHeaders: headers
        )

        return ApolloClient(networkTransport: transport, store: store)
    }
}
