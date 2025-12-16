import SwiftUI

struct BrowseView: View {
    var body: some View {
        PlaceholderView("浏览", description: "后续：来源/扩展列表、搜索、热门/最新")
    }
}

#Preview {
    NavigationStack {
        BrowseView()
    }
}
