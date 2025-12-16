import SwiftUI

struct LibraryView: View {
    var body: some View {
        PlaceholderView("书库", description: "MVP：先验证Tab与导航可用，再接入Tachidesk数据")
            .toolbar {
                NavigationLink {
                    ServerSettingsView()
                } label: {
                    Image(systemName: "gear")
                }
            }
    }
}

#Preview {
    NavigationStack {
        LibraryView()
    }
}
