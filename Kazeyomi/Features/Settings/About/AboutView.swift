import Foundation
import SwiftUI

struct AboutView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings

    @State private var serverAbout: AboutServerPayload?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section(String(localized: "settings.about.section.kazeyomi")) {
                LabeledContent(String(localized: "settings.about.label.version")) {
                    Text(appVersionDisplay)
                        .foregroundStyle(.secondary)
                }
            }

            Section("settings.server.title") {
                if let serverAbout {
                    LabeledContent(String(localized: "settings.about.label.name")) {
                        Text(serverAbout.name)
                            .foregroundStyle(.secondary)
                    }

                    LabeledContent(String(localized: "settings.about.label.channel")) {
                        Text(serverAbout.buildType)
                            .foregroundStyle(.secondary)
                    }

                    LabeledContent(String(localized: "settings.about.label.version")) {
                        Text(serverAbout.version)
                            .foregroundStyle(.secondary)
                    }

                    if let buildTime = buildTimeDisplay(from: serverAbout.buildTime) {
                        LabeledContent(String(localized: "settings.about.label.build_time")) {
                            Text(buildTime)
                                .foregroundStyle(.secondary)
                        }
                    }
                } else if isLoading {
                    HStack {
                        Text("server.status.checking")
                            .foregroundStyle(.secondary)
                        Spacer()
                        ProgressView()
                    }
                } else if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                } else {
                    Text("-")
                        .foregroundStyle(.secondary)
                }
            }

            if let serverAbout {
                Section(String(localized: "settings.about.section.links")) {
                    if let githubURL = URL(string: serverAbout.github) {
                        Link(serverAbout.github, destination: githubURL)
                    }
                    if let discordURL = URL(string: serverAbout.discord) {
                        Link(serverAbout.discord, destination: discordURL)
                    }
                }
            }
        }
        .navigationTitle("settings.about.title")
        .task(id: TaskKey.serverSettings(
            baseURLString: serverSettings.baseURLString,
            addPort: serverSettings.addPort,
            port: serverSettings.port,
            useBasicAuth: serverSettings.useBasicAuth,
            username: serverSettings.username,
            password: serverSettings.password
        )) {
            await load()
        }
    }

    private var appVersionDisplay: String {
        let short = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String

        switch (short?.isEmpty == false ? short : nil, build?.isEmpty == false ? build : nil) {
        case (let short?, let build?):
            return "\(short) (\(build))"
        case (let short?, nil):
            return short
        case (nil, let build?):
            return build
        default:
            return "-"
        }
    }

    private func buildTimeDisplay(from raw: String) -> String? {
        guard let epoch = Double(raw) else { return nil }
        let seconds = epoch > 10_000_000_000 ? (epoch / 1000.0) : epoch
        let date = Date(timeIntervalSince1970: seconds)

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }

    @MainActor
    private func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            serverAbout = try await TachideskClient(serverSettings: serverSettings).aboutServer()
        } catch {
            serverAbout = nil
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
    .environment(ServerSettingsStore())
}
