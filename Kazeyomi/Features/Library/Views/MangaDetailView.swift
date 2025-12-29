import SwiftUI

struct MangaDetailView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @Environment(\.openURL) private var openURL
    @State private var viewModel = MangaDetailViewModel()

    @State private var activeReaderChapter: MangaChapter?

    private enum ActiveSheet: Identifiable {
        case addToLibrary
        case editCategories

        var id: Int {
            switch self {
            case .addToLibrary: return 1
            case .editCategories: return 2
            }
        }
    }

    @State private var activeSheet: ActiveSheet?

    let mangaID: Int

    private var continueChapter: MangaChapter? {
        viewModel.chapters.first(where: { !$0.isRead }) ?? viewModel.chapters.first
    }

    private var startChapter: MangaChapter? {
        guard let first = viewModel.chapters.first, let last = viewModel.chapters.last else { return nil }
        // If the list is sorted newest-first (common), start-from-beginning should open the last row.
        // If it's oldest-first, it should open the first row.
        return first.chapterNumber >= last.chapterNumber ? last : first
    }

    var body: some View {
        List {
            if viewModel.isLoading && viewModel.manga == nil {
                Section {
                    ProgressView("加载中…")
                }
            } else if let errorMessage = viewModel.errorMessage {
                Section {
                    Text("加载失败：\(errorMessage)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            if let manga = viewModel.manga {
                Section {
                    HStack(alignment: .top, spacing: 12) {
                        AuthorizedAsyncImage(
                            url: serverSettings.resolvedURL(manga.thumbnailUrl),
                            authorization: serverSettings.authorizationHeaderValue
                        ) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.secondary.opacity(0.15)
                        }
                        .frame(width: 84, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        VStack(alignment: .leading, spacing: 6) {
                            Text(manga.title)
                                .font(.headline)

                            if let author = manga.author, !author.isEmpty {
                                Text(author)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            } else if let artist = manga.artist, !artist.isEmpty {
                                Text(artist)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }

                            HStack(spacing: 8) {
                                Text(manga.status)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                if manga.unreadCount > 0 {
                                    Text("未读 \(manga.unreadCount)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            if !manga.genres.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 6) {
                                        ForEach(manga.genres, id: \.self) { genre in
                                            Text(genre)
                                                .font(.caption)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                .background(.thinMaterial, in: Capsule())
                                        }
                                    }
                                }
                            }

                            if !manga.categories.isEmpty {
                                Text(manga.categories.map(\.name).joined(separator: " · "))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 4)
                }

                if let description = manga.description, !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Section("简介") {
                        Text(description)
                            .font(.body)
                    }
                }

                Section("章节") {
                    if viewModel.chapters.isEmpty {
                        Text("暂无章节")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.chapters) { chapter in
                            NavigationLink {
                                ReaderView(
                                    chapterID: chapter.id,
                                    title: chapter.name
                                )
                            } label: {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(chapter.name)
                                            .lineLimit(2)

                                        HStack(spacing: 6) {
                                            Text("#\(formatChapterNumber(chapter.chapterNumber))")
                                            if let scanlator = chapter.scanlator, !scanlator.isEmpty {
                                                Text("· \(scanlator)")
                                            }
                                        }
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    if chapter.isDownloaded {
                                        Image(systemName: "arrow.down.circle")
                                            .foregroundStyle(.secondary)
                                    }

                                    if chapter.isRead {
                                        Image(systemName: "checkmark.circle")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.manga?.title ?? "详情")
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
#endif
        .navigationDestination(item: $activeReaderChapter) { chapter in
            ReaderView(
                chapterID: chapter.id,
                title: chapter.name
            )
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if viewModel.manga != nil {
                HStack(spacing: 12) {
                    Button {
                        if let chapter = startChapter {
                            activeReaderChapter = chapter
                        }
                    } label: {
                        Text("从头开始")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(startChapter == nil)

                    Button {
                        if let chapter = continueChapter {
                            activeReaderChapter = chapter
                        }
                    } label: {
                        Text("继续阅读")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(continueChapter == nil)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.regularMaterial)
            }
        }
        .task(id: "\(TaskKey.forServerSettings(serverSettings))|manga:\(mangaID)") {
            await viewModel.load(serverSettings: serverSettings, mangaID: mangaID)
        }
        .refreshable {
            await viewModel.load(serverSettings: serverSettings, mangaID: mangaID, forceFetchChapters: true)
        }
        .toolbar {
            ToolbarItem(placement: {
#if os(macOS)
                .primaryAction
#else
                .topBarTrailing
#endif
            }()) {
                if let manga = viewModel.manga {
                    Menu {
                        if manga.inLibrary {
                            Button {
                                Task { await viewModel.toggleInLibrary(serverSettings: serverSettings, mangaID: mangaID) }
                            } label: {
                                Label("移出书架", systemImage: "bookmark.slash")
                            }
                            .disabled(viewModel.isUpdatingLibrary)
                        } else {
                            Button {
                                activeSheet = .addToLibrary
                            } label: {
                                Label("添加到书架", systemImage: "bookmark")
                            }
                            .disabled(viewModel.isUpdatingLibrary || viewModel.isUpdatingCategories)
                        }

                        Button {
                            activeSheet = .editCategories
                        } label: {
                            Label("编辑分类", systemImage: "folder")
                        }
                        .disabled(viewModel.isUpdatingCategories)

                        Button {
                            openInBrowser()
                        } label: {
                            Label("在浏览器打开", systemImage: "safari")
                        }
                        .disabled(viewModel.browserURLString == nil)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .accessibilityLabel("更多操作")
                }
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .addToLibrary:
                MangaCategoriesEditorView(
                    title: "添加到书架",
                    selectedCategoryIDs: []
                ) { ids in
                    await viewModel.addToLibrary(serverSettings: serverSettings, mangaID: mangaID, categoryIDs: ids)
                }
            case .editCategories:
                MangaCategoriesEditorView(
                    selectedCategoryIDs: viewModel.manga?.categories.map(\.id) ?? []
                ) { ids in
                    await viewModel.updateCategories(serverSettings: serverSettings, mangaID: mangaID, categoryIDs: ids)
                }
            }
        }
    }

    private func formatChapterNumber(_ value: Double) -> String {
        // Match Sorayomi-like display: show integers without trailing .0
        if value.rounded(.towardZero) == value {
            return String(Int(value))
        }
        return String(value)
    }

    private func openInBrowser() {
        guard let urlString = viewModel.browserURLString else { return }
        guard let url = serverSettings.resolvedURL(urlString) else { return }
        openURL(url)
    }
}

#Preview {
    NavigationStack {
        MangaDetailView(mangaID: 1)
            .environment(ServerSettingsStore())
    }
}
