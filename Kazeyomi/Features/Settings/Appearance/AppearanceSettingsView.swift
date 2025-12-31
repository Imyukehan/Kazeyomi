import SwiftUI

struct AppearanceSettingsView: View {
    var body: some View {
        PlaceholderView("settings.appearance.title", description: "settings.appearance.placeholder")
    }
}

#Preview {
    NavigationStack {
        AppearanceSettingsView()
    }
}
