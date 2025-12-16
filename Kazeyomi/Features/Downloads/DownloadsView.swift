import SwiftUI

struct DownloadsView: View {
    var body: some View {
        PlaceholderView("下载", description: "后续：队列管理、进度订阅、删除与重试")
    }
}

#Preview {
    NavigationStack {
        DownloadsView()
    }
}
