import SwiftUI

struct LibraryView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = LibraryViewModel()
    @State private var mangaListViewModel = CategoryMangaListViewModel()
    @State private var selectedCategoryID: Int?

    private var selectedCategory: Category? {
        guard let selectedCategoryID else { return nil }
        return viewModel.categories.first(where: { $0.id == selectedCategoryID })
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.categories.isEmpty {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage, viewModel.categories.isEmpty {
                ContentUnavailableView {
                    Label("加载失败", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(errorMessage)
                }
            } else if viewModel.categories.isEmpty {
                ContentUnavailableView {
                    Label("暂无书库内容", systemImage: "books.vertical")
                } description: {
                    Text("请先在服务端创建分类或将漫画加入书库")
                }
            } else {
                Group {
                    if mangaListViewModel.isLoading && mangaListViewModel.mangas.isEmpty {
                        ProgressView()
                    } else if let errorMessage = mangaListViewModel.errorMessage {
                        ContentUnavailableView {
                            Label("加载失败", systemImage: "exclamationmark.triangle")
                        } description: {
                            Text(errorMessage)
                        }
                    } else if mangaListViewModel.mangas.isEmpty {
                        ContentUnavailableView {
                            Label("暂无漫画", systemImage: "books.vertical")
                        } description: {
                            Text("当前分类下没有漫画，或需要先在服务端添加到书库")
                        }
                    } else {
                        List(mangaListViewModel.mangas, id: \.id) { manga in
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
                    }
                }
            }
        }
        .navigationTitle(selectedCategory.map { "书库 · \($0.name)" } ?? "书库")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    ForEach(viewModel.categories, id: \.id) { category in
                        Button {
                            selectedCategoryID = category.id
                        } label: {
                            if selectedCategoryID == category.id {
                                Label(category.name, systemImage: "checkmark")
                            } else {
                                Text(category.name)
                            }
                        }
                    }
                } label: {
                    Label(selectedCategory?.name ?? "分类", systemImage: "line.3.horizontal.decrease.circle")
                }
                .disabled(viewModel.categories.isEmpty)
            }
        }
        .task(id: TaskKey.forServerSettings(serverSettings)) {
            await viewModel.load(serverSettings: serverSettings)

            if let selectedCategoryID,
               !viewModel.categories.contains(where: { $0.id == selectedCategoryID }) {
                self.selectedCategoryID = nil
            }

            if selectedCategoryID == nil {
                selectedCategoryID = viewModel.categories.first(where: { $0.isDefault })?.id
                    ?? viewModel.categories.first?.id
            }
        }
        .task(id: "\(TaskKey.forServerSettings(serverSettings))|category:\(selectedCategoryID ?? -1)") {
            guard let selectedCategoryID else { return }
            await mangaListViewModel.load(serverSettings: serverSettings, categoryID: selectedCategoryID)
        }
        .refreshable {
            await viewModel.load(serverSettings: serverSettings)

            if let selectedCategoryID,
               !viewModel.categories.contains(where: { $0.id == selectedCategoryID }) {
                self.selectedCategoryID = nil
            }

            if selectedCategoryID == nil {
                selectedCategoryID = viewModel.categories.first(where: { $0.isDefault })?.id
                    ?? viewModel.categories.first?.id
            }

            if let selectedCategoryID {
                await mangaListViewModel.load(serverSettings: serverSettings, categoryID: selectedCategoryID)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LibraryView()
    }
}
