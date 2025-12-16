import Foundation

enum TaskKey {
    static func serverSettings(
        baseURLString: String,
        addPort: Bool,
        port: Int,
        useBasicAuth: Bool,
        username: String,
        password: String
    ) -> String {
        "\(baseURLString)|\(addPort)|\(port)|\(useBasicAuth)|\(username)|\(password)"
    }
}
