import SwiftUI

struct PlaceholderView: View {
    let titleKey: LocalizedStringKey
    let descriptionKey: LocalizedStringKey

    init(_ titleKey: LocalizedStringKey, description descriptionKey: LocalizedStringKey) {
        self.titleKey = titleKey
        self.descriptionKey = descriptionKey
    }

    var body: some View {
        ContentUnavailableView {
            Label(titleKey, systemImage: "globe")
        } description: {
            Text(descriptionKey)
        }
        .navigationTitle(titleKey)
    }
}

#Preview {
    NavigationStack {
        PlaceholderView("placeholder.example.title", description: "placeholder.example.description")
    }
}
