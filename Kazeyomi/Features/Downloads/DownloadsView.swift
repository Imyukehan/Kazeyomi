import SwiftUI

struct DownloadsView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = DownloadsViewModel()

    var body: some View {
        List {
            Section("downloads.section.summary") {
                if viewModel.isLoading {
                    HStack {
                        Text("common.loading")
                        Spacer()
                        ProgressView()
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    Text(String(format: String(localized: "common.load_failed_format"), errorMessage))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } else if let summary = viewModel.summary {
                    LabeledContent("downloads.label.downloader_status") {
                        Text(summary.state)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    LabeledContent("downloads.label.queue") {
                        Text("\(summary.total)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    LabeledContent("downloads.label.in_progress") {
                        Text("\(summary.downloading)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    LabeledContent("downloads.label.queued") {
                        Text("\(summary.queued)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    LabeledContent("downloads.label.failed") {
                        Text("\(summary.error)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("common.placeholder.dash")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                Text("downloads.todo_note")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("downloads.title")
        .task(id: TaskKey.serverSettings(
            baseURLString: serverSettings.baseURLString,
            addPort: serverSettings.addPort,
            port: serverSettings.port,
            useBasicAuth: serverSettings.useBasicAuth,
            username: serverSettings.username,
            password: serverSettings.password
        )) {
            await viewModel.load(serverSettings: serverSettings)
        }
        .refreshable {
            await viewModel.load(serverSettings: serverSettings)
        }
    }
}

#Preview {
    NavigationStack {
        DownloadsView()
    }
}
