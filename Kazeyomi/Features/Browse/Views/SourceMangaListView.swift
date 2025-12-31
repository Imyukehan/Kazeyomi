import SwiftUI

struct SourceMangaListView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = SourceMangaListViewModel()
    @State private var searchText = ""

    let source: Source

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.mangas.isEmpty {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage, viewModel.mangas.isEmpty {
                ContentUnavailableView {
                    Label("common.load_failed", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(errorMessage)
                }
            } else if viewModel.mangas.isEmpty {
                ContentUnavailableView {
                    Label("browse.manga.empty_title", systemImage: "books.vertical")
                } description: {
                    Text("browse.manga.empty_message")
                }
            } else {
                List {
                    ForEach(viewModel.mangas, id: \.id) { manga in
                        NavigationLink {
                            MangaDetailView(mangaID: manga.id)
                        } label: {
                            HStack(spacing: 12) {
                                if let url = serverSettings.resolvedURL(manga.thumbnailUrl) {
                                    AuthorizedAsyncImage(url: url, authorization: serverSettings.authorizationHeaderValue) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 84, height: 120)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.quaternary)
                                        .frame(width: 84, height: 120)
                                        .overlay {
                                            Image(systemName: "book")
                                                .foregroundStyle(.secondary)
                                        }
                                }

                                Text(manga.title)
                                    .font(.headline)
                                    .lineLimit(2)

                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    if viewModel.hasNextPage {
                        Button {
                            Task {
                                await viewModel.loadMoreCurrent(serverSettings: serverSettings, sourceID: source.id)
                            }
                        } label: {
                            HStack {
                                Spacer()
                                if viewModel.isLoading {
                                    ProgressView()
                                } else {
                                    Text("common.load_more")
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(source.displayName)
#if !os(macOS)
        .toolbar(.hidden, for: .tabBar)
#endif
        .toolbar {
            ToolbarItem(placement: {
#if os(macOS)
                .primaryAction
#else
                .topBarTrailing
#endif
            }()) {
                NavigationLink {
                    SourceSettingsView(sourceID: source.id)
                } label: {
                    Image(systemName: "gear")
                }
                .accessibilityLabel("action.settings")
            }
        }
        .searchable(text: $searchText, placement: .toolbar, prompt: "common.search_placeholder")
        .onSubmit(of: .search) {
            Task { await viewModel.search(serverSettings: serverSettings, sourceID: source.id, query: searchText) }
        }
        .onChange(of: searchText) { _, newValue in
            if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Task { await viewModel.search(serverSettings: serverSettings, sourceID: source.id, query: "") }
            }
        }
        .task(id: "\(TaskKey.forServerSettings(serverSettings))|source:\(source.id)") {
            await viewModel.load(
                serverSettings: serverSettings,
                sourceID: source.id
            )
        }
        .refreshable {
            await viewModel.reload(serverSettings: serverSettings, sourceID: source.id)
        }
    }
}

#Preview {
    NavigationStack {
        SourceMangaListView(
            source: Source(
                id: "1",
                name: "source",
                displayName: "Example Source",
                lang: "en",
                iconUrl: "",
                isNsfw: false,
                supportsLatest: true
            )
        )
    }
    .environment(ServerSettingsStore())
}
