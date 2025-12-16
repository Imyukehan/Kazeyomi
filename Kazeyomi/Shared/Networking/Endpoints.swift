import Foundation

enum Endpoints {
    /// Mimic Sorayomi behavior: baseUrl + optional port + /api/graphql
    static func graphQL(baseURL: URL, port: Int?, addPort: Bool) -> URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)

        if let port, addPort {
            components?.port = port
        }

        var path = components?.path ?? ""
        if !path.hasSuffix("/") { path += "/" }
        path += "api/graphql"
        components?.path = path

        guard let url = components?.url else {
            return baseURL
        }
        return url
    }
}
