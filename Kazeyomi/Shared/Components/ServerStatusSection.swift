import SwiftUI

struct ServerStatusSection: View {
    @Environment(ServerSettingsStore.self) private var serverSettings

    @State private var isLoading = false
    @State private var message: String = ""
    @State private var isError = false

    var body: some View {
        Section("服务端") {
            LabeledContent("GraphQL Endpoint") {
                Text(endpointDisplay)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Label(statusTitle, systemImage: statusIcon)
                Spacer()
                if isLoading {
                    ProgressView()
                }
            }

            if !message.isEmpty {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(isError ? .red : .secondary)
            }
        }
        .task(id: TaskKey.serverSettings(
            baseURLString: serverSettings.baseURLString,
            addPort: serverSettings.addPort,
            port: serverSettings.port,
            useBasicAuth: serverSettings.useBasicAuth,
            username: serverSettings.username,
            password: serverSettings.password
        )) {
            await refresh()
        }
    }

    private var endpointDisplay: String {
        (try? serverSettings.graphQLEndpointURL().absoluteString) ?? "-"
    }

    private var statusTitle: String {
        if isLoading { return "连接检测中" }
        return isError ? "连接异常" : "已连接"
    }

    private var statusIcon: String {
        if isLoading { return "arrow.triangle.2.circlepath" }
        return isError ? "exclamationmark.triangle" : "checkmark.seal"
    }

    @MainActor
    private func refresh() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let about = try await TachideskClient(serverSettings: serverSettings).aboutServer()
            isError = false
            message = "\(about.name) \(about.version) (\(about.buildType))"
        } catch {
            isError = true
            message = error.localizedDescription
        }
    }
}

#Preview {
    Form {
        ServerStatusSection()
    }
    .environment(ServerSettingsStore())
}
