import SwiftUI

struct AppRootView: View {
    #if !os(macOS)
    private enum RootTab: String, CaseIterable, Identifiable {
        case library
        case browse
        case updates
        case history
        case settings

        var id: String { rawValue }

        var title: String {
            switch self {
            case .library: return "书库"
            case .browse: return "浏览"
            case .updates: return "更新"
            case .history: return "历史"
            case .settings: return "设置"
            }
        }

        var systemImage: String {
            switch self {
            case .library: return "books.vertical"
            case .browse: return "safari"
            case .updates: return "arrow.triangle.2.circlepath"
            case .history: return "clock"
            case .settings: return "gearshape"
            }
        }
    }

    @State private var selection: RootTab = .library
    #endif

    #if os(macOS)
    private enum SidebarItem: String, CaseIterable, Identifiable {
        case library
        case browse
        case updates
        case history
        case downloads
        case settings

        var id: String { rawValue }

        var title: String {
            switch self {
            case .library: return "书库"
            case .browse: return "浏览"
            case .updates: return "更新"
            case .history: return "历史"
            case .downloads: return "下载"
            case .settings: return "设置"
            }
        }

        var systemImage: String {
            switch self {
            case .library: return "books.vertical"
            case .browse: return "safari"
            case .updates: return "arrow.triangle.2.circlepath"
            case .history: return "clock"
            case .downloads: return "arrow.down.circle"
            case .settings: return "gearshape"
            }
        }
    }

    @State private var selection: SidebarItem = .library
    #endif

    var body: some View {
        #if os(macOS)
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(SidebarItem.allCases) { item in
                    Label(item.title, systemImage: item.systemImage)
                        .tag(item)
                }
            }
            .listStyle(.sidebar)
        } detail: {
            NavigationStack {
                switch selection {
                case .library:
                    LibraryView()
                case .browse:
                    BrowseView()
                case .updates:
                    UpdatesView()
                case .history:
                    HistoryView()
                case .downloads:
                    DownloadsView()
                case .settings:
                    SettingsView()
                }
            }
        }
        #else
        NavigationStack {
            Group {
                switch selection {
                case .library:
                    LibraryView()
                case .browse:
                    BrowseView()
                case .updates:
                    UpdatesView()
                case .history:
                    HistoryView()
                case .settings:
                    SettingsView()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        selection = .library
                    } label: {
                        Label(RootTab.library.title, systemImage: RootTab.library.systemImage)
                    }
                    .disabled(selection == .library)

                    Spacer(minLength: 0)

                    Button {
                        selection = .browse
                    } label: {
                        Label(RootTab.browse.title, systemImage: RootTab.browse.systemImage)
                    }
                    .disabled(selection == .browse)

                    Spacer(minLength: 0)

                    Button {
                        selection = .updates
                    } label: {
                        Label(RootTab.updates.title, systemImage: RootTab.updates.systemImage)
                    }
                    .disabled(selection == .updates)

                    Spacer(minLength: 0)

                    Button {
                        selection = .history
                    } label: {
                        Label(RootTab.history.title, systemImage: RootTab.history.systemImage)
                    }
                    .disabled(selection == .history)

                    Spacer(minLength: 0)

                    Button {
                        selection = .settings
                    } label: {
                        Label(RootTab.settings.title, systemImage: RootTab.settings.systemImage)
                    }
                    .disabled(selection == .settings)
                }
            }
        }
        #endif
    }
}

#Preview {
    AppRootView()
}
