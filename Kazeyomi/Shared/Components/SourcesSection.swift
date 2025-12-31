import SwiftUI

struct SourcesSection: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = SourcesViewModel()

    let title: LocalizedStringKey

    init(title: LocalizedStringKey = "sources.title") {
        self.title = title
    }

    var body: some View {
        Section(title) {
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
            } else if viewModel.sources.isEmpty {
                Text("sources.empty_title")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.sources) { source in
                    HStack(spacing: 12) {
                        if let url = serverSettings.resolvedURL(source.iconUrl) {
                            AuthorizedAsyncImage(url: url, authorization: serverSettings.authorizationHeaderValue) { image in
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
        SourcesSection(title: "sources.title")
    }
    .environment(ServerSettingsStore())
}
