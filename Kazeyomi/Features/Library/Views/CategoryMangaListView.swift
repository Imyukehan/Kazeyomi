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
                    Label("加载失败", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(errorMessage)
                }
            } else if viewModel.mangas.isEmpty {
                ContentUnavailableView {
                    Label("暂无漫画", systemImage: "books.vertical")
                } description: {
                    Text("该分类下没有漫画，或需要先在服务端添加到书库")
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
        CategoryMangaListView(category: Category(id: 1, name: "示例分类", order: 0, isDefault: true))
    }
    .environment(ServerSettingsStore())
}
