import SwiftUI

struct BrowseView: View {
    private enum BrowseSection: String, CaseIterable, Identifiable {
        case sources
        case extensions
        case migration

        var id: String { rawValue }

        var titleKey: LocalizedStringKey {
            switch self {
            case .sources: return "sources.title"
            case .extensions: return "extensions.title"
            case .migration: return "migration.title"
            }
        }

        var titleString: String {
            switch self {
            case .sources: return String(localized: "sources.title")
            case .extensions: return String(localized: "extensions.title")
            case .migration: return String(localized: "migration.title")
            }
        }

        var systemImage: String {
            switch self {
            case .sources: return "square.stack.3d.up"
            case .extensions: return "puzzlepiece.extension"
            case .migration: return "arrow.left.arrow.right"
            }
        }
    }

    @State private var selectedSection: BrowseSection = .sources

    var body: some View {
        Group {
            switch selectedSection {
            case .sources:
                BrowseSourcesView()
            case .extensions:
                BrowseExtensionsView()
            case .migration:
                BrowseMigrationView()
            }
        }
        .navigationTitle(
            String(format: String(localized: "browse.title_with_section_format"), selectedSection.titleString)
        )
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    ForEach(BrowseSection.allCases) { section in
                        Button {
                            selectedSection = section
                        } label: {
                            if selectedSection == section {
                                Label(section.titleKey, systemImage: "checkmark")
                            } else {
                                Label(section.titleKey, systemImage: section.systemImage)
                            }
                        }
                    }
                } label: {
                    Label(selectedSection.titleKey, systemImage: "line.3.horizontal.decrease.circle")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        BrowseView()
    }
}
