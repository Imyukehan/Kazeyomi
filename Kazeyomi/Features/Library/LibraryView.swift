import SwiftUI

struct LibraryView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = LibraryViewModel()

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
            } else if viewModel.categories.isEmpty {
                ContentUnavailableView {
                    Label("暂无分类", systemImage: "books.vertical")
                } description: {
                    Text("请先在服务端创建分类或将漫画加入书库")
                }
            } else {
                List(viewModel.categories, id: \.id) { category in
                    NavigationLink {
                        CategoryMangaListView(category: category)
                    } label: {
                        Text(category.name)
                    }
                }
            }
        }
        .navigationTitle("书库")
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
        .toolbar {
            NavigationLink {
                ServerSettingsView()
            } label: {
                Image(systemName: "gear")
            }
        }
    }
}

#Preview {
    NavigationStack {
        LibraryView()
    }
}
