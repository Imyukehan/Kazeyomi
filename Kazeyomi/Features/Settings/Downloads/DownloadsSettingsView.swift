import SwiftUI

struct DownloadsSettingsView: View {
    var body: some View {
        PlaceholderView("settings.downloads.title", description: "settings.downloads.placeholder")
    }
}

#Preview {
    NavigationStack {
        DownloadsSettingsView()
    }
}
