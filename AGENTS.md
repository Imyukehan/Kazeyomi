# AGENTS.md

This file provides guidance for AI coding agents (Copilot, Claude, etc.) when working in this repository.

## Goals

- Keep the app **always buildable and runnable**.
- Prefer **Apple-first / native APIs**.
- Develop **incrementally**: ship a working skeleton first, then wire real data and interactions.
- Follow the project’s **feature-first** structure and keep changes **small and reversible**.

## Project Structure (Feature-first + Shared)

Source root: `Kazeyomi/Kazeyomi/`

- `App/` — App entry and global wiring
  - `KazeyomiApp.swift` — `@main`, mounts the root view
  - `AppRootView.swift` — Tab + Navigation skeleton
- `Features/` — Feature modules
  - `Library/`, `Browse/`, `Updates/`, `History/`, `Downloads/`, `Reader/`, `Settings/`, …
  - When a feature grows, you may add:
    - `Views/` — screens and subviews
    - `Models/` — lightweight feature-specific models (DTO / presentation models)
    - `ViewModels/` — only if the existing feature already uses them; keep thin
- `Shared/` — Cross-feature reusable layers
  - `Components/` — reusable SwiftUI UI components
  - `Models/` — shared lightweight models
  - `Networking/` — URLSession + GraphQL wrappers; **no networking in Views**
  - `GraphQL/` — schema + operations (generated types live in codegen output)
  - `Persistence/` — UserDefaults / SwiftData wrappers (centralize keys)
  - `Utilities/` — pure helpers (no UI/network/storage)

## Architecture & SwiftUI Guidance

- Prefer **modern SwiftUI data flow**:
  - `@State` for local view state
  - `@Binding` for two-way parent/child state
  - `@Environment` for injected dependencies
  - Use Observation (`@Observable`) for shared state/services when appropriate
- Keep state **close to where it is used** (state flows down, actions flow up).
- Avoid unnecessary abstractions. SwiftUI views should be small and composable.

### ViewModels

- This repo contains a `Shared/ViewModels/` directory and some legacy MVVM usage.
- For **new** code: prefer SwiftUI/Observation patterns and keep logic in services/loaders.
- If you are extending an existing feature that already uses ViewModels, follow the local pattern and keep ViewModels thin.

## Networking Rules

- **GraphQL**: use Apollo iOS (type-safe, cached, codegen). Do not craft GraphQL requests in Views.
- **Non-GraphQL**: use `URLSession`.
- All network access must live in `Shared/Networking/`.

### GraphQL Alignment Policy (WebUI is the source of truth)

When adding or changing GraphQL behavior:

1. Check the official WebUI implementation first:
   - `Suwayomi-WebUI/src/lib/graphql/**`
2. Update this repo’s GraphQL assets:
   - `Shared/GraphQL/Schema/schema.graphqls`
   - `Shared/GraphQL/Operations/*.graphql`
3. Regenerate code via the existing codegen tooling.

Do **not** guess fields/arguments. If behavior differs between older clients and WebUI, implement **WebUI behavior**.

## Development Workflow (Incremental, Always Green)

- Prefer small PR-sized changes.
- Each step should compile and the primary flow should work:
  - App launches
  - Tabs switch
  - Navigation skeleton is intact

### Build Verification

After code changes:

- Ensure the project builds in Xcode.
- If using CLI builds, run an appropriate `xcodebuild` for the scheme/workspace you are modifying.
- If you touched generated GraphQL code, re-run codegen and confirm compilation.

(If you cannot run builds in your environment, call it out explicitly in your final message.)

## Formatting & Style

- Swift formatting: **SwiftFormat**, **2-space indentation** (see `.swiftformat`).
- Follow existing naming conventions:
  - Types: `PascalCase`
  - Functions/variables: `camelCase`
  - File name matches the primary type.
- Avoid unrelated reformatting and large mechanical diffs.

## UI Placement Rules

- Views go under their feature folder, e.g. `Features/Library/LibraryView.swift`.
- Reusable components belong in `Shared/Components/`.
- App wiring belongs in `App/`.

## Persistence Rules

- Centralize settings in `Shared/Persistence/`.
- Prefer `UserDefaults` for settings and `SwiftData` for structured local data.
- Do not scatter UserDefaults keys across the codebase.

## Do / Don’t

**Do**

- Keep changes focused and reversible.
- Prefer native Apple APIs.
- Keep Views declarative and side-effect free; do side effects in `.task`, services, or loaders.
- Align GraphQL with WebUI before implementing.

**Don’t**

- Don’t put networking directly in Views.
- Don’t invent GraphQL fields/arguments.
- Don’t add new architecture layers without a clear need.
- Don’t break the feature-first folder conventions.

## iOS 26 SDK Integration

**IMPORTANT**: The project now supports iOS 26 SDK (June 2025) while maintaining iOS 18 as the minimum deployment target. Use `#available` checks when adopting iOS 26+ APIs. Use swift-expert-skills when needed for info about swiftui design pattern and ios 26 SDK.

### Available iOS 26 SwiftUI APIs

#### Liquid Glass Effects
- `glassEffect(_:in:isEnabled:)` - Apply Liquid Glass effects to views
- `buttonStyle(.glass)` - Apply Liquid Glass styling to buttons
- `ToolbarSpacer` - Create visual breaks in toolbars with Liquid Glass

Example:
```swift
Button("Post", action: postStatus)
    .buttonStyle(.glass)
    .glassEffect(.thin, in: .rect(cornerRadius: 12))
```

#### Enhanced Scrolling
- `scrollEdgeEffectStyle(_:for:)` - Configure scroll edge effects
- `backgroundExtensionEffect()` - Duplicate, mirror, and blur views around edges

#### Tab Bar Enhancements
- `tabBarMinimizeBehavior(_:)` - Control tab bar minimization behavior
- Search role for tabs with search field replacing tab bar
- `TabViewBottomAccessoryPlacement` - Adjust accessory view content based on placement

#### Web Integration
- `WebView` and `WebPage` - Full control over browsing experience

#### Drag and Drop
- `draggable(_:_:)` - Drag multiple items
- `dragContainer(for:id:in:selection:_:)` - Container for draggable views

#### Animation
- `@Animatable` macro - SwiftUI synthesizes custom animatable data properties

#### UI Components
- `Slider` with automatic tick marks when using step parameter
- `windowResizeAnchor(_:)` - Set window anchor point for resizing

#### Text Enhancements
- `TextEditor` now supports `AttributedString`
- `AttributedTextSelection` - Handle text selection with attributed text
- `AttributedTextFormattingDefinition` - Define text styling in specific contexts
- `FindContext` - Create find navigator in text editing views

#### Accessibility
- `AssistiveAccess` - Support Assistive Access in iOS/iPadOS scenes

#### HDR Support
- `Color.ResolvedHDR` - RGBA values with HDR headroom information

#### UIKit Integration
- `UIHostingSceneDelegate` - Host and present SwiftUI scenes in UIKit
- `NSHostingSceneRepresentation` - Host SwiftUI scenes in AppKit
- `NSGestureRecognizerRepresentable` - Incorporate gesture recognizers from AppKit

#### Immersive Spaces (visionOS)
- `manipulable(coordinateSpace:operations:inertia:isEnabled:onChanged:)` - Hand gesture manipulation
- `SurfaceSnappingInfo` - Snap volumes and windows to surfaces
- `RemoteImmersiveSpace` - Render stereo content from Mac to Apple Vision Pro
- `SpatialContainer` - 3D layout container
- Depth-based modifiers: `aspectRatio3D(_:contentMode:)`, `rotation3DLayout(_:)`, `depthAlignment(_:)`

### Usage Guidelines
- Use `#available(iOS 26, *)` for iOS 26-only features
- Replace legacy implementations with iOS 26 APIs where appropriate
- Leverage Liquid Glass effects for modern UI aesthetics in timeline and status views
- Use enhanced text capabilities for the status composer
- Apply new drag-and-drop APIs for media and status interactions

## Commit Convention

Use Conventional Commits:

- `<type>(<scope>): <subject>`
- Types: `feat`, `fix`, `docs`, `refactor`, `chore`, `test`, `build`
- Scopes: prefer feature/layer names like `library`, `updates`, `history`, `networking`

Examples:

- `feat(library): add manga detail page`
- `fix(networking): resolve relative image URLs`
- `docs: add AGENTS guidance`
