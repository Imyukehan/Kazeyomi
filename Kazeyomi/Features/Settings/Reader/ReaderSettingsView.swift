import SwiftUI

struct ReaderSettingsView: View {
    var body: some View {
        PlaceholderView("settings.reader.title", description: "settings.reader.placeholder")
    }
}

#Preview {
    NavigationStack {
        ReaderSettingsView()
    }
}
