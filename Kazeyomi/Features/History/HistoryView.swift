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
                    title: String(localized: "history.unknown_date"),
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
            } else if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(String(format: String(localized: "common.load_failed_format"), errorMessage))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            } else if filteredItems.isEmpty {
                Section {
                    Text(searchText.isEmpty ? "history.empty_title" : "history.search.no_results")
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
                                        HStack(spacing: 8) {
                                            Text(item.manga.title)
                                                .font(.headline)
                                                .lineLimit(1)

                                            if item.manga.inLibrary == false {
                                                Text("history.badge.not_in_library")
                                                    .font(.caption2)
                                                    .foregroundStyle(.secondary)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(.quaternary)
                                                    .clipShape(Capsule())
                                            }

                                            Spacer(minLength: 0)
                                        }

                                        Text(item.name ?? "-")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(2)
                                    }
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
                                    Text("action.remove")
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("history.title")
        .searchable(text: $searchText, prompt: "common.search_placeholder")
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
