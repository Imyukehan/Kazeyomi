import SwiftUI

struct UpdatesView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = UpdatesViewModel()

    private struct SectionGroup: Identifiable {
        let id: String
        let title: String
        let sortDate: Date?
        let items: [ChapterWithManga]
    }

    private var groups: [SectionGroup] {
        let calendar = Calendar.current
        var buckets: [Date: [ChapterWithManga]] = [:]
        var unknown: [ChapterWithManga] = []

        for item in viewModel.items {
            guard let fetchedAt = item.fetchedAt,
                  let date = Timestamps.date(fromLongString: fetchedAt)
            else {
                unknown.append(item)
                continue
            }

            let day = calendar.startOfDay(for: date)
            buckets[day, default: []].append(item)
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
                    title: "未知日期",
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
                    ProgressView("加载中…")
                }
            } else if viewModel.items.isEmpty {
                Section {
                    Text("暂无更新")
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

                                        Text(item.name ?? "-")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(2)
                                    }
                                }
                            }
                            .onAppear {
                                guard item.id == viewModel.items.last?.id else { return }
                                guard viewModel.canLoadMore, !viewModel.isLoading else { return }
                                Task { await viewModel.loadMore(serverSettings: serverSettings) }
                            }
                        }

                        if viewModel.isLoading && !viewModel.items.isEmpty {
                            ProgressView("加载更多…")
                        }
                    }
                }
            }
        }
        .navigationTitle("更新")
        .toolbar {
            ToolbarItem(placement: {
#if os(macOS)
                .primaryAction
#else
                .topBarTrailing
#endif
            }()) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Button {
                        Task { await viewModel.refresh(serverSettings: serverSettings) }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .accessibilityLabel("刷新")
                }
            }
        }
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
