import SwiftUI

struct SourceSettingsView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = SourceSettingsViewModel()

    let sourceID: String

    var body: some View {
        List {
            if viewModel.isLoading && viewModel.preferences.isEmpty {
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

            if !viewModel.isConfigurable {
                Section {
                    Text("该图源暂无可配置项")
                        .foregroundStyle(.secondary)
                }
            } else if viewModel.preferences.isEmpty, !viewModel.isLoading {
                Section {
                    Text("暂无设置")
                        .foregroundStyle(.secondary)
                }
            } else {
                ForEach(viewModel.preferences) { preference in
                    preferenceRow(preference)
                }
            }
        }
        .navigationTitle(viewModel.displayName.isEmpty ? "设置" : viewModel.displayName)
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
#endif
        .task(id: "\(TaskKey.forServerSettings(serverSettings))|sourceSettings:\(sourceID)") {
            await viewModel.load(serverSettings: serverSettings, sourceID: sourceID)
        }
        .refreshable {
            await viewModel.load(serverSettings: serverSettings, sourceID: sourceID)
        }
    }

    @ViewBuilder
    private func preferenceRow(_ preference: SourcePreferenceItem) -> some View {
        switch preference {
        case .toggle(let position, _, let title, let summary, let value, _):
            Toggle(isOn: Binding(
                get: { value },
                set: { newValue in
                    Task {
                        await viewModel.update(
                            serverSettings: serverSettings,
                            sourceID: sourceID,
                            change: TachideskAPI.SourcePreferenceChangeInput(
                                position: position,
                                switchState: .some(newValue)
                            )
                        )
                    }
                }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                    if let summary, !summary.isEmpty {
                        Text(summary)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .disabled(viewModel.isLoading)

        case .checkBox(let position, _, let title, let summary, let value, _):
            Toggle(isOn: Binding(
                get: { value },
                set: { newValue in
                    Task {
                        await viewModel.update(
                            serverSettings: serverSettings,
                            sourceID: sourceID,
                            change: TachideskAPI.SourcePreferenceChangeInput(
                                checkBoxState: .some(newValue),
                                position: position
                            )
                        )
                    }
                }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                    if let summary, !summary.isEmpty {
                        Text(summary)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .disabled(viewModel.isLoading)

        case .list(let position, _, let title, let summary, let value, _, let entries, let entryValues):
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                    if let summary, !summary.isEmpty {
                        Text(summary)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Picker(
                    selection: Binding(
                        get: { value },
                        set: { newValue in
                            Task {
                                await viewModel.update(
                                    serverSettings: serverSettings,
                                    sourceID: sourceID,
                                    change: TachideskAPI.SourcePreferenceChangeInput(
                                        listState: .some(newValue),
                                        position: position
                                    )
                                )
                            }
                        }
                    ),
                    label: EmptyView()
                ) {
                    ForEach(Array(entryValues.enumerated()), id: \.offset) { idx, entryValue in
                        Text(entries.indices.contains(idx) ? entries[idx] : entryValue)
                            .tag(entryValue)
                    }
                }
                .pickerStyle(.menu)
                .disabled(viewModel.isLoading)
            }

        case .editText(let position, _, let title, let summary, let value, _, let dialogTitle, let dialogMessage):
            NavigationLink {
                SourceEditTextPreferenceView(
                    title: dialogTitle ?? title,
                    message: dialogMessage,
                    initialValue: value
                ) { newValue in
                    await viewModel.update(
                        serverSettings: serverSettings,
                        sourceID: sourceID,
                        change: TachideskAPI.SourcePreferenceChangeInput(
                            editTextState: .some(newValue),
                            position: position
                        )
                    )
                }
            } label: {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                    if let summary, !summary.isEmpty {
                        Text(summary)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    } else {
                        Text(value)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .disabled(viewModel.isLoading)

        case .multiSelect(
            let position,
            _,
            let title,
            let summary,
            let values,
            _,
            let entries,
            let entryValues,
            let dialogTitle,
            let dialogMessage
        ):
            NavigationLink {
                SourceMultiSelectPreferenceView(
                    title: dialogTitle ?? title,
                    message: dialogMessage,
                    entries: entries,
                    entryValues: entryValues,
                    selectedValues: values
                ) { newValues in
                    await viewModel.update(
                        serverSettings: serverSettings,
                        sourceID: sourceID,
                        change: TachideskAPI.SourcePreferenceChangeInput(
                            multiSelectState: .some(newValues),
                            position: position
                        )
                    )
                }
            } label: {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                    if let summary, !summary.isEmpty {
                        Text(summary)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    } else {
                        Text(values.joined(separator: ", "))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .disabled(viewModel.isLoading)
        }
    }
}

private struct SourceEditTextPreferenceView: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let message: String?
    let initialValue: String
    let onSave: (String) async -> Void

    @State private var text: String
    @State private var isSaving = false

    init(title: String, message: String?, initialValue: String, onSave: @escaping (String) async -> Void) {
        self.title = title
        self.message = message
        self.initialValue = initialValue
        self.onSave = onSave
        _text = State(initialValue: initialValue)
    }

    var body: some View {
        Form {
            if let message, !message.isEmpty {
                Section {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                TextField("", text: $text)
#if !os(macOS)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
#endif
            }
        }
        .navigationTitle(title)
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
        .toolbar {
            ToolbarItem(placement: {
#if os(macOS)
                .primaryAction
#else
                .topBarTrailing
#endif
            }()) {
                if isSaving {
                    ProgressView()
                } else {
                    Button("保存") {
                        Task {
                            isSaving = true
                            await onSave(text)
                            isSaving = false
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

private struct SourceMultiSelectPreferenceView: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let message: String?
    let entries: [String]
    let entryValues: [String]
    let onSave: ([String]) async -> Void

    @State private var selected: Set<String>
    @State private var isSaving = false

    init(
        title: String,
        message: String?,
        entries: [String],
        entryValues: [String],
        selectedValues: [String],
        onSave: @escaping ([String]) async -> Void
    ) {
        self.title = title
        self.message = message
        self.entries = entries
        self.entryValues = entryValues
        self.onSave = onSave
        _selected = State(initialValue: Set(selectedValues))
    }

    var body: some View {
        List {
            if let message, !message.isEmpty {
                Section {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                ForEach(Array(entryValues.enumerated()), id: \.offset) { idx, value in
                    Button {
                        if selected.contains(value) {
                            selected.remove(value)
                        } else {
                            selected.insert(value)
                        }
                    } label: {
                        HStack {
                            Text(entries.indices.contains(idx) ? entries[idx] : value)
                            Spacer()
                            if selected.contains(value) {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
    #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
    #endif
        .toolbar {
            ToolbarItem(placement: {
#if os(macOS)
                .primaryAction
#else
                .topBarTrailing
#endif
            }()) {
                if isSaving {
                    ProgressView()
                } else {
                    Button("保存") {
                        Task {
                            isSaving = true
                            await onSave(Array(selected))
                            isSaving = false
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SourceSettingsView(sourceID: "1")
            .environment(ServerSettingsStore())
    }
}
