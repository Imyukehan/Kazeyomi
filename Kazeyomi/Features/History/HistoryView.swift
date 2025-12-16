import SwiftUI

struct HistoryView: View {
    var body: some View {
        List {
            ServerStatusSection()

            SourcesSection(title: "Sources")

            Section("历史") {
                Label("按日期分组", systemImage: "calendar")
                Label("继续阅读入口", systemImage: "play.circle")
                Label("搜索历史", systemImage: "magnifyingglass")
            }

            Section {
                Text("后续：从服务端拉取阅读历史，并支持移除/继续阅读。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("历史")
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
}
