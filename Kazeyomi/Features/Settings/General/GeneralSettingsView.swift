import SwiftUI

struct GeneralSettingsView: View {
    var body: some View {
        PlaceholderView("settings.general.title", description: "settings.general.placeholder")
    }
}

#Preview {
    NavigationStack {
        GeneralSettingsView()
    }
}
