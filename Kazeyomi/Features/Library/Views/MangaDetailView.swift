import SwiftUI

struct MangaDetailView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = MangaDetailViewModel()

    let mangaID: Int

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
                                Text(manga.genres.joined(separator: " · "))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
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
        .navigationBarTitleDisplayMode(.inline)
        .task(id: "\(TaskKey.forServerSettings(serverSettings))|manga:\(mangaID)") {
            await viewModel.load(serverSettings: serverSettings, mangaID: mangaID)
        }
        .refreshable {
            await viewModel.load(serverSettings: serverSettings, mangaID: mangaID)
        }
    }

    private func formatChapterNumber(_ value: Double) -> String {
        // Match Sorayomi-like display: show integers without trailing .0
        if value.rounded(.towardZero) == value {
            return String(Int(value))
        }
        return String(value)
    }
}

#Preview {
    NavigationStack {
        MangaDetailView(mangaID: 1)
            .environment(ServerSettingsStore())
    }
}
