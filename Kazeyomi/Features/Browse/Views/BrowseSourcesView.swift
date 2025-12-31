import SwiftUI

struct BrowseSourcesView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = SourcesViewModel()

    @AppStorage("browse.enabledSourceLanguages") private var enabledLanguagesJSON = ""
    @State private var isShowingLanguagePicker = false

    private var availableLanguages: [String] {
        let langs = Set(viewModel.sources.map { $0.lang })
        return langs.sorted()
    }

    private var enabledLanguages: Set<String> {
        get {
            guard let data = enabledLanguagesJSON.data(using: .utf8), !enabledLanguagesJSON.isEmpty else {
                return []
            }
            return (try? JSONDecoder().decode([String].self, from: data)).map(Set.init) ?? []
        }
        nonmutating set {
            let array = Array(newValue).sorted()
            if let data = try? JSONEncoder().encode(array), let string = String(data: data, encoding: .utf8) {
                enabledLanguagesJSON = string
            } else {
                enabledLanguagesJSON = ""
            }
        }
    }

    private var filteredSources: [Source] {
        let enabled = enabledLanguages
        guard !enabled.isEmpty else { return [] }
        return viewModel.sources.filter { enabled.contains($0.lang) }
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.sources.isEmpty {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage, viewModel.sources.isEmpty {
                ContentUnavailableView {
                    Label("common.load_failed", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(errorMessage)
                }
            } else if filteredSources.isEmpty {
                ContentUnavailableView {
                    Label("sources.empty_title", systemImage: "square.stack.3d.up")
                } description: {
                    Text("sources.empty_message_no_language")
                }
            } else {
                List(filteredSources) { source in
                    NavigationLink {
                        SourceMangaListView(source: source)
                    } label: {
                        HStack(spacing: 12) {
                            if let url = serverSettings.resolvedURL(source.iconUrl) {
                                AuthorizedAsyncImage(url: url, authorization: serverSettings.authorizationHeaderValue) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 24, height: 24)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            } else {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.quaternary)
                                    .frame(width: 24, height: 24)
                                    .overlay {
                                        Image(systemName: "square.stack.3d.up")
                                            .foregroundStyle(.secondary)
                                    }
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(source.displayName)
                                    .lineLimit(1)

                                Text("\(source.lang) · \(source.isNsfw ? "NSFW" : "SFW")")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if source.supportsLatest {
                                Image(systemName: "bolt.horizontal")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
        }
        .navigationTitle("sources.title")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    // Placeholder: Search UI/behavior not implemented yet.
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .disabled(true)

                Button {
                    isShowingLanguagePicker = true
                } label: {
                    Image(systemName: "globe")
                }
                .disabled(availableLanguages.isEmpty)
            }
        }
        .task(id: TaskKey.forServerSettings(serverSettings)) {
            await viewModel.load(serverSettings: serverSettings)
        }
        .onChange(of: viewModel.sources) { _, newValue in
            initializeLanguagesIfNeeded(sources: newValue)
        }
        .task {
            initializeLanguagesIfNeeded(sources: viewModel.sources)
        }
        .refreshable {
            await viewModel.load(serverSettings: serverSettings)
        }
        .sheet(isPresented: $isShowingLanguagePicker) {
            LanguagePickerSheet(
                availableLanguages: availableLanguages,
                enabledLanguages: Binding(
                    get: { enabledLanguages },
                    set: { enabledLanguages = $0 }
                )
            )
        }
    }

    private func initializeLanguagesIfNeeded(sources: [Source]) {
        guard !sources.isEmpty else { return }
        guard enabledLanguagesJSON.isEmpty else { return }

        let available = Set(sources.map(\.lang))
        if let device = systemLanguageCode(), available.contains(device) {
            enabledLanguages = [device]
        } else {
            // Fallback: avoid showing an empty list when the server's language codes
            // don't match the user's device locale.
            enabledLanguages = available
        }
    }

    private func systemLanguageCode() -> String? {
        if #available(iOS 16.0, macOS 13.0, *) {
            return Locale.current.language.languageCode?.identifier
        }
        guard let raw = Locale.preferredLanguages.first, !raw.isEmpty else { return nil }
        return raw.split(separator: "-").first.map(String.init)
    }
}

private struct LanguagePickerSheet: View {
    @Environment(\.dismiss) private var dismiss

    let availableLanguages: [String]
    @Binding var enabledLanguages: Set<String>

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(availableLanguages, id: \.self) { lang in
                        Toggle(isOn: Binding(
                            get: { enabledLanguages.contains(lang) },
                            set: { isOn in
                                if isOn {
                                    enabledLanguages.insert(lang)
                                } else {
                                    enabledLanguages.remove(lang)
                                }
                            }
                        )) {
                            Text(lang)
                        }
                    }
                }
            }
            .navigationTitle("browse.language.title")
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItem(placement: {
#if os(macOS)
                    .confirmationAction
#else
                    .topBarTrailing
#endif
                }()) {
                    Button("action.done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        BrowseSourcesView()
    }
    .environment(ServerSettingsStore())
}
