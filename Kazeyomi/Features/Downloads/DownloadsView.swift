import SwiftUI

struct DownloadsView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = DownloadsViewModel()

    var body: some View {
        List {
            ServerStatusSection()

            Section("摘要") {
                if viewModel.isLoading {
                    HStack {
                        Text("加载中")
                        Spacer()
                        ProgressView()
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    Text("加载失败：\(errorMessage)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } else if let summary = viewModel.summary {
                    LabeledContent("下载器状态") {
                        Text(summary.state)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    LabeledContent("队列") {
                        Text("\(summary.total)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    LabeledContent("进行中") {
                        Text("\(summary.downloading)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    LabeledContent("排队") {
                        Text("\(summary.queued)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    LabeledContent("失败") {
                        Text("\(summary.error)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("-")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                Text("后续：下载队列列表、拖拽排序、开始/停止、下载进度订阅。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("下载")
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
