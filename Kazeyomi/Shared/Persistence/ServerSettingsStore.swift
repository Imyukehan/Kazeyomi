import Foundation
import Observation

@Observable
final class ServerSettingsStore {
    private enum Keys {
        static let baseURLString = "kazeyomi.server.baseURLString"
        static let addPort = "kazeyomi.server.addPort"
        static let port = "kazeyomi.server.port"
        static let useBasicAuth = "kazeyomi.server.useBasicAuth"
        static let username = "kazeyomi.server.username"
        static let password = "kazeyomi.server.password"
    }

    @ObservationIgnored
    private let defaults: UserDefaults

    var baseURLString: String {
        didSet { defaults.set(baseURLString, forKey: Keys.baseURLString) }
    }

    var addPort: Bool {
        didSet { defaults.set(addPort, forKey: Keys.addPort) }
    }

    var port: Int {
        didSet { defaults.set(port, forKey: Keys.port) }
    }

    var useBasicAuth: Bool {
        didSet { defaults.set(useBasicAuth, forKey: Keys.useBasicAuth) }
    }

    var username: String {
        didSet { defaults.set(username, forKey: Keys.username) }
    }

    var password: String {
        didSet { defaults.set(password, forKey: Keys.password) }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        self.baseURLString = defaults.string(forKey: Keys.baseURLString) ?? "http://127.0.0.1"
        self.addPort = defaults.object(forKey: Keys.addPort) as? Bool ?? true
        self.port = defaults.object(forKey: Keys.port) as? Int ?? 4567

        self.useBasicAuth = defaults.object(forKey: Keys.useBasicAuth) as? Bool ?? false
        self.username = defaults.string(forKey: Keys.username) ?? ""
        self.password = defaults.string(forKey: Keys.password) ?? ""
    }

    func baseURL() throws -> URL {
        guard let url = URL(string: baseURLString), url.scheme != nil else {
            throw URLError(.badURL)
        }
        return url
    }

    func graphQLEndpointURL() throws -> URL {
        let url = try baseURL()
        return Endpoints.graphQL(baseURL: url, port: port, addPort: addPort)
    }

    var authorizationHeaderValue: String? {
        guard useBasicAuth else { return nil }
        guard !username.isEmpty || !password.isEmpty else { return nil }

        let raw = "\(username):\(password)"
        guard let data = raw.data(using: .utf8) else { return nil }
        return "Basic \(data.base64EncodedString())"
    }
}
