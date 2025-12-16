import SwiftUI

struct PlaceholderView: View {
    let title: String
    let description: String

    init(_ title: String, description: String) {
        self.title = title
        self.description = description
    }

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "globe")
        } description: {
            Text(description)
        }
        .navigationTitle(title)
    }
}

#Preview {
    NavigationStack {
        PlaceholderView("示例", description: "这里将逐步替换为真实功能")
    }
}
