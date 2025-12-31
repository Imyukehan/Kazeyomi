import SwiftUI

struct BrowseSettingsView: View {
    var body: some View {
        PlaceholderView("settings.browse.title", description: "settings.browse.placeholder")
    }
}

#Preview {
    NavigationStack {
        BrowseSettingsView()
    }
}
