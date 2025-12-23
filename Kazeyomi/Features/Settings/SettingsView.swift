import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            NavigationLink {
                GeneralSettingsView()
            } label: {
                Label("通用", systemImage: "tune")
            }

            NavigationLink {
                AppearanceSettingsView()
            } label: {
                Label("外观", systemImage: "paintpalette")
            }

            NavigationLink {
                LibrarySettingsView()
            } label: {
                Label("书库", systemImage: "books.vertical")
            }

            NavigationLink {
                DownloadsSettingsView()
            } label: {
                Label("下载", systemImage: "arrow.down.circle")
            }

            NavigationLink {
                ReaderSettingsView()
            } label: {
                Label("阅读器", systemImage: "doc.text.magnifyingglass")
            }

            NavigationLink {
                BrowseSettingsView()
            } label: {
                Label("浏览", systemImage: "safari")
            }

            NavigationLink {
                BackupSettingsView()
            } label: {
                Label("备份", systemImage: "externaldrive")
            }

            NavigationLink {
                ServerSettingsView()
            } label: {
                Label("服务器", systemImage: "server.rack")
            }
        }
        .navigationTitle("设置")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
