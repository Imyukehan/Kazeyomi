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
        case about

        var id: String { rawValue }

        var title: LocalizedStringKey {
            switch self {
            case .library: return "tab.library"
            case .browse: return "tab.browse"
            case .updates: return "tab.updates"
            case .history: return "tab.history"
            case .downloads: return "tab.downloads"
            case .settings: return "tab.settings"
            case .about: return "tab.about"
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
            case .about: return "info.circle"
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
                case .about:
                    AboutView()
                }
            }
        }
        #else
        TabView {
            NavigationStack {
                LibraryView()
            }
            .tabItem {
                Label("tab.library", systemImage: "books.vertical")
            }

            NavigationStack {
                BrowseView()
            }
            .tabItem {
                Label("tab.browse", systemImage: "safari")
            }

            NavigationStack {
                UpdatesView()
            }
            .tabItem {
                Label("tab.updates", systemImage: "arrow.triangle.2.circlepath")
            }

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("tab.history", systemImage: "clock")
            }

            NavigationStack {
                DownloadsView()
            }
            .tabItem {
                Label("tab.downloads", systemImage: "arrow.down.circle")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("tab.settings", systemImage: "gearshape")
            }

            NavigationStack {
                AboutView()
            }
            .tabItem {
                Label("tab.about", systemImage: "info.circle")
            }
        }
        #endif
    }
}

#Preview {
    AppRootView()
}
