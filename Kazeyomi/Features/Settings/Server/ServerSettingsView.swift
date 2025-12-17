import SwiftUI

struct ServerSettingsView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings

    @State private var isTesting = false
    @State private var testMessage: String?

    @ViewBuilder
    private var formContent: some View {
        Section("服务器") {
            TextField("Base URL", text: Bindable(serverSettings).baseURLString)
            #if !os(macOS)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            #endif

            Toggle("添加端口", isOn: Bindable(serverSettings).addPort)

            Stepper(value: Bindable(serverSettings).port, in: 1...65535) {
                HStack {
                    Text("端口")
                    Spacer()
                    Text("\(serverSettings.port)")
                        .foregroundStyle(.secondary)
                }
            }
        }

        Section("认证") {
            Toggle("Basic Auth", isOn: Bindable(serverSettings).useBasicAuth)

            TextField("用户名", text: Bindable(serverSettings).username)
            #if !os(macOS)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            #endif
                .disabled(!serverSettings.useBasicAuth)

            SecureField("密码", text: Bindable(serverSettings).password)
                .disabled(!serverSettings.useBasicAuth)
        }

        Section {
            Button {
                Task { await testConnection() }
            } label: {
                HStack {
                    Text("测试连接")
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
        .navigationTitle("服务器设置")
        #else
        Form {
            formContent
        }
        .navigationTitle("服务器设置")
        #endif
    }

    @MainActor
    private func testConnection() async {
        isTesting = true
        defer { isTesting = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let about = try await client.aboutServer()
            testMessage = "✅ \(about.name) \(about.version) (\(about.buildType))"
        } catch {
            testMessage = "❌ 连接失败：\(error.localizedDescription)"
        }
    }
}

#Preview {
    NavigationStack {
        ServerSettingsView()
    }
    .environment(ServerSettingsStore())
}
