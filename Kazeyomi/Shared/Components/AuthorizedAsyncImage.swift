import SwiftUI
import Combine

#if canImport(UIKit)
import UIKit
private typealias PlatformImage = UIImage
private extension Image {
    init(platformImage: PlatformImage) {
        self.init(uiImage: platformImage)
    }
}
#elseif canImport(AppKit)
import AppKit
private typealias PlatformImage = NSImage
private extension Image {
    init(platformImage: PlatformImage) {
        self.init(nsImage: platformImage)
    }
}
#endif

struct AuthorizedAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let authorization: String?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    @StateObject private var loader = Loader()

    init(
        url: URL?,
        authorization: String?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.authorization = authorization
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let platformImage = loader.image {
                content(Image(platformImage: platformImage))
            } else {
                placeholder()
            }
        }
        .task(id: taskID) {
            await loader.load(url: url, authorization: authorization)
        }
    }

    private var taskID: String {
        [url?.absoluteString ?? "", authorization ?? ""].joined(separator: "|")
    }
}

@MainActor
private final class Loader: ObservableObject {
    @Published var image: PlatformImage?

    func load(url: URL?, authorization: String?) async {
        guard let url else {
            image = nil
            return
        }

        if let cached = ImageCache.shared.get(url: url, authorization: authorization) {
            image = cached
            return
        }

        var request = URLRequest(url: url)
        if let authorization {
            request.setValue(authorization, forHTTPHeaderField: "Authorization")
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                image = nil
                return
            }

            #if canImport(UIKit)
            guard let decoded = UIImage(data: data) else {
                image = nil
                return
            }
            #elseif canImport(AppKit)
            guard let decoded = NSImage(data: data) else {
                image = nil
                return
            }
            #endif

            ImageCache.shared.set(image: decoded, url: url, authorization: authorization)
            image = decoded
        } catch {
            image = nil
        }
    }
}

private final class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, CacheBox>()

    func get(url: URL, authorization: String?) -> PlatformImage? {
        let key = cacheKey(url: url, authorization: authorization)
        return cache.object(forKey: key)?.image
    }

    func set(image: PlatformImage, url: URL, authorization: String?) {
        let key = cacheKey(url: url, authorization: authorization)
        cache.setObject(CacheBox(image: image), forKey: key)
    }

    private func cacheKey(url: URL, authorization: String?) -> NSString {
        // Include auth to avoid mixing protected/unprotected resources.
        return NSString(string: [url.absoluteString, authorization ?? ""].joined(separator: "|"))
    }
}

private final class CacheBox {
    let image: PlatformImage

    init(image: PlatformImage) {
        self.image = image
    }
}
