import Foundation

struct ExtensionPackage: Identifiable, Hashable {
    var id: String { pkgName }

    let pkgName: String
    let name: String
    let lang: String
    let versionName: String
    let versionCode: Int
    let iconUrl: String
    let isInstalled: Bool
    let hasUpdate: Bool
    let isObsolete: Bool
    let isNsfw: Bool
    let repo: String?
    let apkName: String
}
