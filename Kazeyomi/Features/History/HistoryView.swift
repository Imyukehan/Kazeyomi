import SwiftUI

struct HistoryView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = HistoryViewModel()
    @State private var searchText = ""

    private struct SectionGroup: Identifiable {
        let id: String
        let title: String
        let sortDate: Date?
        let items: [ChapterWithManga]
    }

    private var filteredItems: [ChapterWithManga] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return viewModel.items }
        return viewModel.items.filter {
            $0.manga.title.localizedCaseInsensitiveContains(q) ||
                ($0.name ?? "").localizedCaseInsensitiveContains(q)
        }
    }

    private var groups: [SectionGroup] {
        let calendar = Calendar.current
        var buckets: [Date: [ChapterWithManga]] = [:]
        var unknown: [ChapterWithManga] = []

        for item in filteredItems {
            guard let lastReadAt = item.lastReadAt,
                  let date = Timestamps.date(fromLongString: lastReadAt)
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
            ServerStatusSection()

            if viewModel.isLoading && viewModel.items.isEmpty {
                Section {
                    ProgressView("加载中…")
                }
            } else if let errorMessage = viewModel.errorMessage {
                Section {
                    Text("加载失败：\(errorMessage)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            } else if filteredItems.isEmpty {
                Section {
                    Text(searchText.isEmpty ? "暂无历史" : "没有匹配结果")
                        .foregroundStyle(.secondary)
                }
            } else {
                ForEach(groups) { group in
                    Section(group.title) {
                        ForEach(group.items) { item in
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: item.manga.thumbnailUrl ?? "")) { image in
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
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.removeFromHistory(
                                            serverSettings: serverSettings,
                                            chapterID: item.id
                                        )
                                    }
                                } label: {
                                    Text("移除")
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("历史")
        .searchable(text: $searchText, prompt: "搜索")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("刷新") {
                    Task { await viewModel.refresh(serverSettings: serverSettings) }
                }
                .disabled(viewModel.isLoading)
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
        HistoryView()
    }
    .environment(ServerSettingsStore())
}
