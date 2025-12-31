import SwiftUI

struct ServerSettingsView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings

    @State private var isTesting = false
    @State private var testMessage: String?

    @ViewBuilder
    private var formContent: some View {
        Section("server.section.server") {
            TextField("server.base_url", text: Bindable(serverSettings).baseURLString)
            #if !os(macOS)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            #endif

            Toggle("server.add_port", isOn: Bindable(serverSettings).addPort)

            Stepper(value: Bindable(serverSettings).port, in: 1...65535) {
                HStack {
                    Text("server.port")
                    Spacer()
                    Text("\(serverSettings.port)")
                        .foregroundStyle(.secondary)
                }
            }
        }

        Section("server.section.auth") {
            Toggle("server.auth.basic", isOn: Bindable(serverSettings).useBasicAuth)

            TextField("server.auth.username", text: Bindable(serverSettings).username)
            #if !os(macOS)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            #endif
                .disabled(!serverSettings.useBasicAuth)

            SecureField("server.auth.password", text: Bindable(serverSettings).password)
                .disabled(!serverSettings.useBasicAuth)
        }

        Section {
            Button {
                Task { await testConnection() }
            } label: {
                HStack {
                    Text("server.test_connection")
                    Spacer()
                    if isTesting {
                        ProgressView()
                    }
                }
            }
            .disabled(isTesting)

            if let testMessage {
                Text(testMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    var body: some View {
        #if os(macOS)
        ScrollView {
            Form {
                formContent
            }
            .formStyle(.grouped)
            .frame(maxWidth: 520)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding()
        }
            .navigationTitle("server.settings.title")
        #else
        Form {
            formContent
        }
            .navigationTitle("server.settings.title")
        #endif
    }

    @MainActor
    private func testConnection() async {
        isTesting = true
        defer { isTesting = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let about = try await client.aboutServer()
            testMessage = String(
                format: String(localized: "server.test.success_format"),
                about.name,
                about.version,
                about.buildType
            )
        } catch {
            testMessage = String(
                format: String(localized: "server.test.failure_format"),
                error.localizedDescription
            )
        }
    }
}

#Preview {
    NavigationStack {
        ServerSettingsView()
    }
    .environment(ServerSettingsStore())
}
