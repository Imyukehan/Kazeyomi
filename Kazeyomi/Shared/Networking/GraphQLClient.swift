import Foundation

struct GraphQLError: Decodable, Error {
    struct Location: Decodable {
        let line: Int?
        let column: Int?
    }

    let message: String
    let locations: [Location]?
}

struct GraphQLResponse<T: Decodable>: Decodable {
    let data: T?
    let errors: [GraphQLError]?
}

final class GraphQLClient {
    struct RequestBody: Encodable {
        let query: String
        let variables: [String: String]?
    }

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func execute<T: Decodable>(
        endpoint: URL,
        query: String,
        variables: [String: String]? = nil,
        authorization: String? = nil
    ) async throws -> T {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if let authorization {
            request.setValue(authorization, forHTTPHeaderField: "Authorization")
        }

        let body = RequestBody(query: query, variables: variables)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await session.data(for: request)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(GraphQLResponse<T>.self, from: data)
        if let firstError = decoded.errors?.first {
            throw firstError
        }

        guard let payload = decoded.data else {
            throw URLError(.cannotParseResponse)
        }

        return payload
    }
}
