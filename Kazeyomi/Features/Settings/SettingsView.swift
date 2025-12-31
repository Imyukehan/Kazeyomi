import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            NavigationLink {
                GeneralSettingsView()
            } label: {
                Label("settings.general.title", systemImage: "tune")
            }

            NavigationLink {
                AppearanceSettingsView()
            } label: {
                Label("settings.appearance.title", systemImage: "paintpalette")
            }

            NavigationLink {
                LibrarySettingsView()
            } label: {
                Label("settings.library.title", systemImage: "books.vertical")
            }

            NavigationLink {
                DownloadsSettingsView()
            } label: {
                Label("settings.downloads.title", systemImage: "arrow.down.circle")
            }

            NavigationLink {
                ReaderSettingsView()
            } label: {
                Label("settings.reader.title", systemImage: "doc.text.magnifyingglass")
            }

            NavigationLink {
                BrowseSettingsView()
            } label: {
                Label("settings.browse.title", systemImage: "safari")
            }

            NavigationLink {
                BackupSettingsView()
            } label: {
                Label("settings.backup.title", systemImage: "externaldrive")
            }

            NavigationLink {
                ServerSettingsView()
            } label: {
                Label("settings.server.title", systemImage: "server.rack")
            }
        }
        .navigationTitle("settings.title")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
