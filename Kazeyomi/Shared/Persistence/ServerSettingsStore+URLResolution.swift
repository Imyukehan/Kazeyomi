import Foundation

extension ServerSettingsStore {
    /// Resolves a URL string that may be absolute (https://...) or relative (/api/...).
    ///
    /// Tachidesk often returns image URLs as relative paths (e.g. "/api/v1/manga/797/thumbnail"),
    /// which will crash URLSession/AsyncImage with NSURLErrorDomain -1002 (unsupported URL)
    /// unless we resolve them against the configured server base URL.
    func resolvedURL(_ urlString: String?) -> URL? {
        guard let urlString, !urlString.isEmpty else { return nil }

        // If it's already an absolute URL, use it as-is.
        if let direct = URL(string: urlString), direct.scheme != nil {
            return direct
        }

        // Fall back to resolving relative URLs against server base URL (+ optional port).
        guard let base = try? baseURL() else {
            return URL(string: urlString)
        }

        var components = URLComponents(url: base, resolvingAgainstBaseURL: false)
        if addPort {
            components?.port = port
        }

        let baseWithPort = components?.url ?? base
        return URL(string: urlString, relativeTo: baseWithPort)?.absoluteURL
    }
}
