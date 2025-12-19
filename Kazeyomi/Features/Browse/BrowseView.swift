import SwiftUI

struct BrowseView: View {
    private enum BrowseSection: String, CaseIterable, Identifiable {
        case sources
        case extensions
        case migration

        var id: String { rawValue }

        var title: String {
            switch self {
            case .sources: return "图源"
            case .extensions: return "插件"
            case .migration: return "迁移"
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
        .navigationTitle("浏览 · \(selectedSection.title)")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    ForEach(BrowseSection.allCases) { section in
                        Button {
                            selectedSection = section
                        } label: {
                            if selectedSection == section {
                                Label(section.title, systemImage: "checkmark")
                            } else {
                                Label(section.title, systemImage: section.systemImage)
                            }
                        }
                    }
                } label: {
                    Label(selectedSection.title, systemImage: "line.3.horizontal.decrease.circle")
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
