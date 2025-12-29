import SwiftUI

struct ReaderView: View {
    @Environment(ServerSettingsStore.self) private var serverSettings
    @State private var viewModel = ReaderViewModel()

    private enum ReaderMode: String, CaseIterable, Identifiable {
        case paged
        case strip

        var id: String { rawValue }

        var title: String {
            switch self {
            case .paged:
                return "分页"
            case .strip:
                return "条漫"
            }
        }
    }

    private enum ReadingDirection: String, CaseIterable, Identifiable {
        case leftToRight
        case rightToLeft

        var id: String { rawValue }

        var title: String {
            switch self {
            case .leftToRight:
                return "从左到右"
            case .rightToLeft:
                return "从右到左"
            }
        }
    }

    @AppStorage("kazeyomi.reader.mode") private var readerModeRawValue: String = ReaderMode.paged.rawValue
    @AppStorage("kazeyomi.reader.readingDirection") private var readingDirectionRawValue: String = ReadingDirection.rightToLeft.rawValue
    @AppStorage("kazeyomi.reader.doublePage") private var isDoublePageEnabled: Bool = false

    @State private var isChromeVisible: Bool = true
    @State private var currentPageIndex: Int = 0
    @State private var isZoomed: Bool = false

    @State private var pageDragOffsetX: CGFloat = 0

    let chapterID: Int
    let title: String

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            Group {
                if viewModel.isLoading && viewModel.pages.isEmpty {
                    ProgressView("加载中…")
                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView {
                        Label("加载失败", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(errorMessage)
                    }
                } else if viewModel.pages.isEmpty {
                    ContentUnavailableView {
                        Label("暂无页面", systemImage: "doc.plaintext")
                    } description: {
                        Text("服务端未返回页面列表")
                    }
                } else {
                    contentView(pages: viewModel.pages)
                }
            }
            .tint(.white)
        }
        .navigationTitle(isChromeVisible ? title : "")
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar(isChromeVisible ? .visible : .hidden, for: .navigationBar)
#endif
        .toolbar {
            if isChromeVisible {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker("浏览模式", selection: $readerModeRawValue) {
                            ForEach(ReaderMode.allCases) { mode in
                                Text(mode.title).tag(mode.rawValue)
                            }
                        }

                        Picker("阅读方向", selection: $readingDirectionRawValue) {
                            ForEach(ReadingDirection.allCases) { dir in
                                Text(dir.title).tag(dir.rawValue)
                            }
                        }

                        Toggle("双页", isOn: $isDoublePageEnabled)
                            .disabled(readerMode != .paged)
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
        .task(id: "\(TaskKey.forServerSettings(serverSettings))|chapter:\(chapterID)") {
            await viewModel.load(serverSettings: serverSettings, chapterID: chapterID)
        }
        .refreshable {
            await viewModel.load(serverSettings: serverSettings, chapterID: chapterID)
        }
    }

    private var readerMode: ReaderMode {
        ReaderMode(rawValue: readerModeRawValue) ?? .paged
    }

    private var readingDirection: ReadingDirection {
        ReadingDirection(rawValue: readingDirectionRawValue) ?? .rightToLeft
    }

    @ViewBuilder
    private func contentView(pages: [String]) -> some View {
        switch readerMode {
        case .paged:
            pagedView(pages: pages)
        case .strip:
            stripView(pages: pages)
        }
    }

    private func stripView(pages: [String]) -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(pages.enumerated()), id: \.offset) { _, page in
                    ReaderPageImage(
                        serverSettings: serverSettings,
                        page: page,
                        maxScale: 5,
                        onZoomChanged: { _ in }
                    )
                    .padding(.vertical, 4)
                }
            }
        }
        .scrollIndicators(.hidden)
        .contentShape(Rectangle())
        .onTapGesture {
            isChromeVisible.toggle()
        }
    }

    private func pagedView(pages: [String]) -> some View {
        let spreadStep = isDoublePageEnabled ? 2 : 1

        return GeometryReader { proxy in
            ZStack {
                spreadContent(pages: pages)
                    .id("page:\(currentPageIndex)|double:\(isDoublePageEnabled ? 1 : 0)")
                    .offset(x: pageDragOffsetX)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isChromeVisible.toggle()
                    }
                    .simultaneousGesture(pageSwipeGesture(pagesCount: pages.count, spreadStep: spreadStep, containerWidth: proxy.size.width))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: pages.count) {
            currentPageIndex = min(currentPageIndex, max(0, pages.count - 1))
        }
        .onChange(of: readerModeRawValue) {
            isZoomed = false
            pageDragOffsetX = 0
        }
        .onChange(of: isDoublePageEnabled) {
            pageDragOffsetX = 0
        }
    }

    private func pageSwipeGesture(pagesCount: Int, spreadStep: Int, containerWidth: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                guard !isZoomed else { return }
                pageDragOffsetX = value.translation.width
            }
            .onEnded { value in
                guard !isZoomed else {
                    pageDragOffsetX = 0
                    return
                }

                let threshold: CGFloat = 60
                let dx = value.translation.width

                guard abs(dx) > threshold else {
                    withAnimation(.easeOut(duration: 0.18)) {
                        pageDragOffsetX = 0
                    }
                    return
                }

                let isNext: Bool
                switch readingDirection {
                case .leftToRight:
                    isNext = dx < 0
                case .rightToLeft:
                    isNext = dx > 0
                }

                let targetIndex: Int
                if isNext {
                    targetIndex = min(currentPageIndex + spreadStep, max(0, pagesCount - 1))
                } else {
                    targetIndex = max(currentPageIndex - spreadStep, 0)
                }

                // Animate the current content off-screen in swipe direction, then swap page.
                let exitOffset = dx >= 0 ? containerWidth : -containerWidth
                withAnimation(.easeOut(duration: 0.15)) {
                    pageDragOffsetX = exitOffset
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    currentPageIndex = targetIndex
                    pageDragOffsetX = 0
                }
            }
    }

    @ViewBuilder
    private func spreadContent(pages: [String]) -> some View {
        if let firstPage = page(at: currentPageIndex, in: pages) {
            let secondPage = isDoublePageEnabled ? page(at: currentPageIndex + 1, in: pages) : nil

            if let secondPage {
                let (left, right) = orderedSpread(first: firstPage, second: secondPage)

                HStack(spacing: 0) {
                    ReaderPageImage(
                        serverSettings: serverSettings,
                        page: left,
                        maxScale: 4,
                        onZoomChanged: { isZoomed = $0 }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    ReaderPageImage(
                        serverSettings: serverSettings,
                        page: right,
                        maxScale: 4,
                        onZoomChanged: { isZoomed = $0 }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                ReaderPageImage(
                    serverSettings: serverSettings,
                    page: firstPage,
                    maxScale: 5,
                    onZoomChanged: { isZoomed = $0 }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            EmptyView()
        }
    }

    private func orderedSpread(first: String, second: String) -> (left: String, right: String) {
        switch readingDirection {
        case .leftToRight:
            return (first, second)
        case .rightToLeft:
            return (second, first)
        }
    }

    private func page(at index: Int, in pages: [String]) -> String? {
        guard pages.indices.contains(index) else { return nil }
        return pages[index]
    }
}

private struct ReaderPageImage: View {
    let serverSettings: ServerSettingsStore
    let page: String
    let maxScale: CGFloat
    let onZoomChanged: (Bool) -> Void

    @State private var scale: CGFloat = 1
    @State private var accumulatedScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var accumulatedOffset: CGSize = .zero

    var body: some View {
        Group {
            if let url = serverSettings.resolvedURL(page) {
                AuthorizedAsyncImage(
                    url: url,
                    authorization: serverSettings.authorizationHeaderValue
                ) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale)
                        .offset(offset)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                VStack(spacing: 8) {
                    Text("无法解析页面 URL")
                        .foregroundStyle(.secondary)
                    Text(page)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 24)
            }
        }
        .clipped()
        .simultaneousGesture(magnificationGesture)
        .simultaneousGesture(dragGesture, including: scale > 1.01 ? .all : .none)
        .onChange(of: scale) {
            onZoomChanged(scale > 1.01)
        }
    }

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let next = accumulatedScale * value
                scale = min(max(1, next), maxScale)
            }
            .onEnded { _ in
                accumulatedScale = scale
                if scale <= 1.01 {
                    resetTransform()
                }
            }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                guard scale > 1.01 else { return }
                offset = CGSize(
                    width: accumulatedOffset.width + value.translation.width,
                    height: accumulatedOffset.height + value.translation.height
                )
            }
            .onEnded { _ in
                accumulatedOffset = offset
            }
    }

    private func resetTransform() {
        scale = 1
        accumulatedScale = 1
        offset = .zero
        accumulatedOffset = .zero
    }
}

#Preview {
    NavigationStack {
        ReaderView(chapterID: 1, title: "示例章节")
            .environment(ServerSettingsStore())
    }
}
