import SwiftUI

struct ServerSettingsView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings

    @State private var isTesting = false
    @State private var testMessage: String?

    var body: some View {
        Form {
            Section("服务器") {
                TextField("Base URL", text: Bindable(serverSettings).baseURLString)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

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
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
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
        .navigationTitle("服务器设置")
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
