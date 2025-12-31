import SwiftUI

struct BrowseExtensionsView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = BrowseExtensionsViewModel()
    @State private var searchText = ""

    @AppStorage("browse.enabledExtensionLanguages") private var enabledLanguagesJSON = ""
    @State private var isShowingLanguagePicker = false
    @State private var isShowingSearch = false
    @FocusState private var isSearchFieldFocused: Bool

    private var availableLanguages: [String] {
        let langs = Set(viewModel.extensions.map { $0.lang })
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

    private var searchFilteredExtensions: [ExtensionPackage] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return viewModel.extensions }
        return viewModel.extensions.filter {
            $0.name.localizedCaseInsensitiveContains(trimmed)
                || $0.pkgName.localizedCaseInsensitiveContains(trimmed)
                || $0.lang.localizedCaseInsensitiveContains(trimmed)
        }
    }

    private var updateExtensions: [ExtensionPackage] {
        searchFilteredExtensions.filter { $0.isInstalled && $0.hasUpdate }
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
    }

    private var installedExtensions: [ExtensionPackage] {
        searchFilteredExtensions.filter { $0.isInstalled && !$0.hasUpdate }
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
    }

    private var availableExtensions: [ExtensionPackage] {
        let enabled = enabledLanguages
        guard !enabled.isEmpty else { return [] }

        return searchFilteredExtensions
            .filter { !$0.isInstalled && enabled.contains($0.lang) }
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
    }

    private func actionTitleKey(for ext: ExtensionPackage) -> LocalizedStringKey {
        if ext.isInstalled {
            return ext.hasUpdate ? "extensions.action.update" : "extensions.action.uninstall"
        }
        return "extensions.action.install"
    }

    private func action(for ext: ExtensionPackage) -> ExtensionUpdateAction {
        if ext.isInstalled {
            return ext.hasUpdate ? .update : .uninstall
        }
        return .install
    }

    @ViewBuilder
    private func row(for ext: ExtensionPackage) -> some View {
        HStack(spacing: 12) {
            if let url = serverSettings.resolvedURL(ext.iconUrl) {
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
                        Image(systemName: "puzzlepiece.extension")
                            .foregroundStyle(.secondary)
                    }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(ext.name)
                    .lineLimit(1)

                Text("\(ext.lang) · \(ext.versionName)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                if ext.isObsolete || ext.isNsfw {
                    HStack(spacing: 6) {
                        if ext.isObsolete {
                            Text("extensions.label.deprecated")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        if ext.isNsfw {
                            Text("NSFW")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Spacer()

            Button {
                Task {
                    await viewModel.perform(action(for: ext), pkgName: ext.pkgName, serverSettings: serverSettings)
                }
            } label: {
                if viewModel.isActive(pkgName: ext.pkgName) {
                    ProgressView()
                } else {
                        Text(actionTitleKey(for: ext))
                }
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.isActive(pkgName: ext.pkgName))
        }
        .padding(.vertical, 2)
    }

    var body: some View {
        let hasAnyResults = !updateExtensions.isEmpty || !installedExtensions.isEmpty || !availableExtensions.isEmpty

        Group {
            if viewModel.isLoading && viewModel.extensions.isEmpty {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage, viewModel.extensions.isEmpty {
                ContentUnavailableView {
                    Label("common.load_failed", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(errorMessage)
                }
            } else if !hasAnyResults {
                ContentUnavailableView {
                    Label("extensions.empty_title", systemImage: "puzzlepiece.extension")
                } description: {
                    if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text("extensions.search.no_matches")
                    } else if viewModel.extensions.isEmpty {
                        Text("extensions.empty_message_failed_to_load")
                    } else if enabledLanguages.isEmpty {
                        Text("extensions.empty_message_no_language")
                    } else {
                        Text("extensions.empty_title")
                    }
                }
            } else {
                List {
                    if isShowingSearch {
                        Section {
                            TextField("common.search_placeholder", text: $searchText)
                                .textFieldStyle(.roundedBorder)
                                .focused($isSearchFieldFocused)
                        }
                    }

                    if !updateExtensions.isEmpty {
                        Section("extensions.section.updatable") {
                            ForEach(updateExtensions) { ext in
                                row(for: ext)
                            }
                        }
                    }

                    if !installedExtensions.isEmpty {
                        Section("extensions.section.installed") {
                            ForEach(installedExtensions) { ext in
                                row(for: ext)
                            }
                        }
                    }

                    if !availableExtensions.isEmpty {
                        Section("extensions.section.available") {
                            ForEach(availableExtensions) { ext in
                                row(for: ext)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("extensions.title")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    if isShowingSearch {
                        isShowingSearch = false
                        searchText = ""
                        isSearchFieldFocused = false
                    } else {
                        isShowingSearch = true
                        isSearchFieldFocused = true
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .disabled(viewModel.extensions.isEmpty && viewModel.isLoading)

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
        .onChange(of: viewModel.extensions) { _, newValue in
            initializeLanguagesIfNeeded(extensions: newValue)
        }
        .task {
            initializeLanguagesIfNeeded(extensions: viewModel.extensions)
        }
        .refreshable {
            await viewModel.refreshRemote(serverSettings: serverSettings)
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

    private func initializeLanguagesIfNeeded(extensions: [ExtensionPackage]) {
        guard !extensions.isEmpty else { return }
        guard enabledLanguagesJSON.isEmpty else { return }

        let available = Set(extensions.map(\.lang))
        if let device = systemLanguageCode(), available.contains(device) {
            enabledLanguages = [device]
        } else {
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
        BrowseExtensionsView()
    }
}
