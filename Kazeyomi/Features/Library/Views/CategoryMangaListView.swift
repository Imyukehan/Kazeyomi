import SwiftUI

struct CategoryMangaListView: View {
    let category: Category

    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = CategoryMangaListViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView {
                    Label("common.load_failed", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(errorMessage)
                }
            } else if viewModel.mangas.isEmpty {
                ContentUnavailableView {
                    Label("library.empty_manga_title", systemImage: "books.vertical")
                } description: {
                    Text("library.empty_manga_message")
                }
            } else {
                List(viewModel.mangas, id: \.id) { manga in
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
                                .frame(width: 44, height: 64)
                                .clipped()
                                .cornerRadius(6)
                            } else {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.quaternary)
                                    .frame(width: 44, height: 64)
                                    .overlay {
                                        Image(systemName: "book")
                                            .foregroundStyle(.secondary)
                                    }
                            }

                            Text(manga.title)
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
        .navigationTitle(category.name)
#if !os(macOS)
        .toolbar(.hidden, for: .tabBar)
#endif
        .task(id: TaskKey.serverSettings(
            baseURLString: serverSettings.baseURLString,
            addPort: serverSettings.addPort,
            port: serverSettings.port,
            useBasicAuth: serverSettings.useBasicAuth,
            username: serverSettings.username,
            password: serverSettings.password
        )) {
            await viewModel.load(serverSettings: serverSettings, categoryID: category.id)
        }
        .refreshable {
            await viewModel.load(serverSettings: serverSettings, categoryID: category.id)
        }
    }
}

#Preview {
    NavigationStack {
        CategoryMangaListView(category: Category(id: 1, name: "Example Category", order: 0, isDefault: true))
    }
    .environment(ServerSettingsStore())
}
