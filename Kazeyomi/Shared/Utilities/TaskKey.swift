import Foundation

enum TaskKey {
    static func forServerSettings(_ serverSettings: ServerSettingsStore) -> String {
        TaskKey.serverSettings(
            baseURLString: serverSettings.baseURLString,
            addPort: serverSettings.addPort,
            port: serverSettings.port,
            useBasicAuth: serverSettings.useBasicAuth,
            username: serverSettings.username,
            password: serverSettings.password
        )
    }

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
