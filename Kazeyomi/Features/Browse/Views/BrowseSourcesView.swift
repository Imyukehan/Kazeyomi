import SwiftUI

struct BrowseSourcesView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = SourcesViewModel()

    @State private var selectedLanguage: String?

    private var availableLanguages: [String] {
        let langs = Set(viewModel.sources.map { $0.lang })
        return langs.sorted()
    }

    private var filteredSources: [Source] {
        guard let selectedLanguage else { return viewModel.sources }
        return viewModel.sources.filter { $0.lang == selectedLanguage }
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.sources.isEmpty {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage, viewModel.sources.isEmpty {
                ContentUnavailableView {
                    Label("加载失败", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(errorMessage)
                }
            } else if filteredSources.isEmpty {
                ContentUnavailableView {
                    Label("暂无图源", systemImage: "square.stack.3d.up")
                } description: {
                    Text(selectedLanguage == nil ? "当前没有可用图源" : "当前语言下没有可用图源")
                }
            } else {
                List(filteredSources) { source in
                    NavigationLink {
                        SourceMangaListView(source: source)
                    } label: {
                        HStack(spacing: 12) {
                            if let url = serverSettings.resolvedURL(source.iconUrl) {
                                AuthorizedAsyncImage(url: url, authorization: serverSettings.authorizationHeaderValue) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 24, height: 24)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            } else {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.quaternary)
                                    .frame(width: 24, height: 24)
                                    .overlay {
                                        Image(systemName: "square.stack.3d.up")
                                            .foregroundStyle(.secondary)
                                    }
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
                        .padding(.vertical, 2)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("图源")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    // Placeholder: Search UI/behavior not implemented yet.
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .disabled(true)

                Menu {
                    Button {
                        selectedLanguage = nil
                    } label: {
                        if selectedLanguage == nil {
                            Label("全部", systemImage: "checkmark")
                        } else {
                            Text("全部")
                        }
                    }

                    ForEach(availableLanguages, id: \.self) { lang in
                        Button {
                            selectedLanguage = lang
                        } label: {
                            if selectedLanguage == lang {
                                Label(lang, systemImage: "checkmark")
                            } else {
                                Text(lang)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "globe")
                }
                .disabled(availableLanguages.isEmpty)
            }
        }
        .task(id: TaskKey.forServerSettings(serverSettings)) {
            await viewModel.load(serverSettings: serverSettings)
        }
        .refreshable {
            await viewModel.load(serverSettings: serverSettings)
        }
    }
}

#Preview {
    NavigationStack {
        BrowseSourcesView()
    }
    .environment(ServerSettingsStore())
}
