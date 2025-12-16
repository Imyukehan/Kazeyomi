import SwiftUI

struct AppRootView: View {
    var body: some View {
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
        }
    }
}

#Preview {
    AppRootView()
}
