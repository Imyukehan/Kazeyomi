import SwiftUI

struct BackupSettingsView: View {
    var body: some View {
        PlaceholderView("settings.backup.title", description: "settings.backup.placeholder")
    }
}

#Preview {
    NavigationStack {
        BackupSettingsView()
    }
}
