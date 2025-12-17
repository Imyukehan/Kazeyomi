import SwiftUI

struct BrowseMigrationView: View {
    var body: some View {
        ContentUnavailableView {
            Label("迁移", systemImage: "arrow.left.arrow.right")
        } description: {
            Text("迁移功能后续对齐 Sorayomi 逐步实现")
        }
        .navigationTitle("迁移")
    }
}

#Preview {
    NavigationStack {
        BrowseMigrationView()
    }
}
