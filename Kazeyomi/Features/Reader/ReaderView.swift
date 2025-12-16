import SwiftUI

struct ReaderView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = ReaderViewModel()

    let chapterID: Int
    let title: String

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.pages.isEmpty {
                ProgressView("加载中…")
            } else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView {
                    Label("加载失败", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(errorMessage)
                }
            } else if viewModel.pages.isEmpty {
                ContentUnavailableView {
                    Label("暂无页面", systemImage: "doc.plaintext")
                } description: {
                    Text("服务端未返回页面列表")
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(viewModel.pages.enumerated()), id: \ .offset) { index, page in
                            if let url = serverSettings.resolvedURL(page) {
                                AuthorizedAsyncImage(
                                    url: url,
                                    authorization: serverSettings.authorizationHeaderValue
                                ) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                }
                            } else {
                                VStack(spacing: 8) {
                                    Text("无法解析页面 URL")
                                        .foregroundStyle(.secondary)
                                    Text(page)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                            }

                            if index != viewModel.pages.count - 1 {
                                Divider()
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .task(id: "\(TaskKey.forServerSettings(serverSettings))|chapter:\(chapterID)") {
            await viewModel.load(serverSettings: serverSettings, chapterID: chapterID)
        }
        .refreshable {
            await viewModel.load(serverSettings: serverSettings, chapterID: chapterID)
        }
    }
}

#Preview {
    NavigationStack {
        ReaderView(chapterID: 1, title: "示例章节")
            .environment(ServerSettingsStore())
    }
}
