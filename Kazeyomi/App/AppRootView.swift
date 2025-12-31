import SwiftUI

struct AppRootView: View {
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
        TabView {
            NavigationStack {
                LibraryView()
            }
            .tabItem {
                Label("书库", systemImage: "books.vertical")
            }

            NavigationStack {
                BrowseView()
            }
            .tabItem {
                Label("浏览", systemImage: "safari")
            }

            NavigationStack {
                UpdatesView()
            }
            .tabItem {
                Label("更新", systemImage: "arrow.triangle.2.circlepath")
            }

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("历史", systemImage: "clock")
            }

            NavigationStack {
                DownloadsView()
            }
            .tabItem {
                Label("下载", systemImage: "arrow.down.circle")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("设置", systemImage: "gearshape")
            }
        }
        #endif
    }
}

#Preview {
    AppRootView()
}
