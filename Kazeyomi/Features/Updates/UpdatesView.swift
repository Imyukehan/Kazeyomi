import SwiftUI

struct UpdatesView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = UpdatesViewModel()

    private struct MangaUpdateRow: Identifiable {
        let id: Int
        let mangaId: Int
        let manga: MangaBase
        let latestChapterName: String
        let chapterCount: Int
        let fetchedAt: String?
    }

    private struct SectionGroup: Identifiable {
        let id: String
        let title: String
        let sortDate: Date?
        let items: [MangaUpdateRow]
    }

    private var groups: [SectionGroup] {
        let calendar = Calendar.current
        var buckets: [Date: [MangaUpdateRow]] = [:]
        var unknown: [MangaUpdateRow] = []

        func append(_ item: ChapterWithManga, to list: inout [MangaUpdateRow]) {
            let latestName = item.name ?? "-"
            if let last = list.last, last.mangaId == item.mangaId {
                list[list.count - 1] = MangaUpdateRow(
                    id: last.id,
                    mangaId: last.mangaId,
                    manga: last.manga,
                    latestChapterName: last.latestChapterName,
                    chapterCount: last.chapterCount + 1,
                    fetchedAt: last.fetchedAt
                )
            } else {
                list.append(
                    MangaUpdateRow(
                        id: item.id,
                        mangaId: item.mangaId,
                        manga: item.manga,
                        latestChapterName: latestName,
                        chapterCount: 1,
                        fetchedAt: item.fetchedAt
                    )
                )
            }
        }

        for item in viewModel.items {
            guard let fetchedAt = item.fetchedAt,
                  let date = Timestamps.date(fromLongString: fetchedAt)
            else {
                append(item, to: &unknown)
                continue
            }

            let day = calendar.startOfDay(for: date)
            var list = buckets[day, default: []]
            append(item, to: &list)
            buckets[day] = list
        }

        var result: [SectionGroup] = buckets
            .map { day, items in
                SectionGroup(
                    id: ISO8601DateFormatter().string(from: day),
                    title: Timestamps.relativeDayTitle(from: day),
                    sortDate: day,
                    items: items
                )
            }
            .sorted { (lhs, rhs) in
                (lhs.sortDate ?? .distantPast) > (rhs.sortDate ?? .distantPast)
            }

        if !unknown.isEmpty {
            result.append(
                SectionGroup(
                    id: "unknown",
                    title: String(localized: "common.unknown_date"),
                    sortDate: nil,
                    items: unknown
                )
            )
        }

        return result
    }

    var body: some View {
        List {
            if viewModel.isLoading && viewModel.items.isEmpty {
                Section {
                    ProgressView("common.loading")
                }
            } else if viewModel.items.isEmpty {
                Section {
                    Text("updates.empty_title")
                        .foregroundStyle(.secondary)
                }
            } else {
                ForEach(groups) { group in
                    Section(group.title) {
                        ForEach(group.items) { item in
                            NavigationLink {
                                MangaDetailView(mangaID: item.mangaId)
                            } label: {
                                HStack(spacing: 12) {
                                    AuthorizedAsyncImage(
                                        url: serverSettings.resolvedURL(item.manga.thumbnailUrl),
                                        authorization: serverSettings.authorizationHeaderValue
                                    ) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Color.secondary.opacity(0.15)
                                    }
                                    .frame(width: 44, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.manga.title)
                                            .font(.headline)
                                            .lineLimit(1)

                                        if item.chapterCount <= 1 {
                                            Text(item.latestChapterName)
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                                .lineLimit(2)
                                        } else {
                                            Text(
                                                String(
                                                    format: String(localized: "updates.latest_and_more_format"),
                                                    item.latestChapterName,
                                                    Int64(item.chapterCount)
                                                )
                                            )
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                                .lineLimit(2)
                                        }
                                    }
                                }
                            }
                            .onAppear {
                                guard group.id == groups.last?.id else { return }
                                guard item.id == group.items.last?.id else { return }
                                guard viewModel.canLoadMore, !viewModel.isLoading else { return }
                                Task { await viewModel.loadMore(serverSettings: serverSettings) }
                            }
                        }

                        if viewModel.isLoading && !viewModel.items.isEmpty {
                            ProgressView("common.loading_more")
                        }
                    }
                }
            }
        }
        .navigationTitle("updates.title")
        .refreshable {
            await viewModel.refresh(serverSettings: serverSettings)
        }
        .task(id: TaskKey.forServerSettings(serverSettings)) {
            await viewModel.refresh(serverSettings: serverSettings)
        }
    }
}

#Preview {
    NavigationStack {
        UpdatesView()
    }
    .environment(ServerSettingsStore())
}
