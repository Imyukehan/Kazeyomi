import Foundation

struct Source: Identifiable, Decodable, Hashable {
    let id: String
    let name: String
    let displayName: String
    let lang: String
    let iconUrl: String
    let isNsfw: Bool
    let supportsLatest: Bool
}
