import SwiftUI

struct BrowseExtensionsView: View {
    var body: some View {
        ContentUnavailableView {
            Label("插件", systemImage: "puzzlepiece.extension")
        } description: {
            Text("插件列表后续对齐 Sorayomi 逐步实现")
        }
        .navigationTitle("插件")
    }
}

#Preview {
    NavigationStack {
        BrowseExtensionsView()
    }
}
