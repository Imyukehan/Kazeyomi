import SwiftUI

struct MangaCategoriesEditorView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = MangaCategoriesEditorViewModel()
    @Binding private var selectedCategoryIDs: Set<Int>

    let title: String
    let onSave: ([Int]) async -> Void

    init(
        title: String = "编辑分类",
        selectedCategoryIDs: Binding<Set<Int>>,
        onSave: @escaping ([Int]) async -> Void
    ) {
        self.title = title
        self.onSave = onSave
        self._selectedCategoryIDs = selectedCategoryIDs
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.categories.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("加载中…")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        if let errorMessage = viewModel.errorMessage {
                            Section {
                                Text("加载失败：\(errorMessage)")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Section {
                            ForEach(viewModel.categories) { category in
                                Toggle(isOn: Binding(
                                    get: { selectedCategoryIDs.contains(category.id) },
                                    set: { isOn in
                                        // Assign a new Set value (instead of mutating in-place)
                                        // to ensure SwiftUI observes the state change reliably.
                                        if isOn {
                                            selectedCategoryIDs = selectedCategoryIDs.union([category.id])
                                        } else {
                                            selectedCategoryIDs = selectedCategoryIDs.subtracting([category.id])
                                        }
                                    }
                                )) {
                                    Text(category.name)
                                }
                            }
                        }
                    }
                    .listStyle({
#if os(macOS)
                        .inset
#else
                        .insetGrouped
#endif
                    }())
                }
            }
            .navigationTitle(title)
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItem(placement: {
#if os(macOS)
                    .cancellationAction
#else
                    .topBarLeading
#endif
                }()) {
                    Button("取消") { dismiss() }
                }

                ToolbarItem(placement: {
#if os(macOS)
                    .confirmationAction
#else
                    .topBarTrailing
#endif
                }()) {
                    Button("保存") {
                        let ids = selectedCategoryIDs
                            .subtracting([0])
                            .sorted()
                        Task {
                            await onSave(ids)
                            dismiss()
                        }
                    }
                }
            }
            .task(id: TaskKey.forServerSettings(serverSettings)) {
                await viewModel.load(serverSettings: serverSettings)
            }
        }
    }
}

#Preview {
    MangaCategoriesEditorView(
        selectedCategoryIDs: .constant([1, 2, 3])
    ) { _ in }
        .environment(ServerSettingsStore())
}
