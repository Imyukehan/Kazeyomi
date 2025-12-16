import SwiftUI

struct BrowseView: View {
    var body: some View {
        List {
            ServerStatusSection()

            SourcesSection(title: "Sources")

            Section("浏览") {
                Label("来源（Sources）", systemImage: "square.stack.3d.up")
                Label("扩展（Extensions）", systemImage: "puzzlepiece.extension")
                Label("搜索（Search）", systemImage: "magnifyingglass")
            }

            Section {
                Text("这里将逐步实现：来源列表、热门/最新、全局搜索。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
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
