import SwiftUI

struct BrowseView: View {
    var body: some View {
        List {
            Section {
                NavigationLink {
                    BrowseSourcesView()
                } label: {
                    Label("图源", systemImage: "square.stack.3d.up")
                }

                NavigationLink {
                    BrowseExtensionsView()
                } label: {
                    Label("插件", systemImage: "puzzlepiece.extension")
                }

                NavigationLink {
                    BrowseMigrationView()
                } label: {
                    Label("迁移", systemImage: "arrow.left.arrow.right")
                }
            }
        }
        .navigationTitle("浏览")
    }
}

#Preview {
    NavigationStack {
        BrowseView()
    }
}
