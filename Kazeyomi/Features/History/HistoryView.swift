import SwiftUI

struct HistoryView: View {
    var body: some View {
        PlaceholderView("历史", description: "后续：阅读历史、继续阅读入口")
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
}
