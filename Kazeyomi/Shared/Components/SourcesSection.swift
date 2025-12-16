import SwiftUI

struct SourcesSection: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = SourcesViewModel()

    let title: String

    init(title: String = "Sources") {
        self.title = title
    }

    var body: some View {
        Section(title) {
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
            } else if viewModel.sources.isEmpty {
                Text("暂无Sources")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.sources) { source in
                    HStack(spacing: 12) {
                        if let url = URL(string: source.iconUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 20, height: 20)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(source.displayName)
                                .lineLimit(1)
                            Text("\(source.lang) · \(source.isNsfw ? "NSFW" : "SFW")")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        if source.supportsLatest {
                            Image(systemName: "bolt.horizontal")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
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
            await viewModel.load(serverSettings: serverSettings)
        }
    }
}

#Preview {
    List {
        SourcesSection(title: "Sources")
    }
    .environment(ServerSettingsStore())
}
