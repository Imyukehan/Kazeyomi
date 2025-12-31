import SwiftUI

struct LibrarySettingsView: View {
    var body: some View {
        PlaceholderView("settings.library.title", description: "settings.library.placeholder")
    }
}

#Preview {
    NavigationStack {
        LibrarySettingsView()
    }
}
