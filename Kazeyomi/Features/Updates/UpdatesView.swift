import SwiftUI

struct UpdatesView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = UpdatesViewModel()

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
                } else {
                    LabeledContent("最后更新时间") {
                        Text(viewModel.lastUpdateTimestamp ?? "-")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                Text("后续：最近章节列表、更新任务状态订阅、批量操作。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("更新")
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
        UpdatesView()
    }
}
