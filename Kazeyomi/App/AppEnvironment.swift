import SwiftUI

extension View {
    func installAppEnvironment() -> some View {
        self.environment(ServerSettingsStore())
    }
}
