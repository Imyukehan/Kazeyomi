import SwiftUI

struct BrowseMigrationView: View {
    var body: some View {
        ContentUnavailableView {
            Label("migration.title", systemImage: "arrow.left.arrow.right")
        } description: {
            Text("browse.migration.placeholder")
        }
        .navigationTitle("migration.title")
    }
}

#Preview {
    NavigationStack {
        BrowseMigrationView()
    }
}
