# Kazeyomi 项目结构与代码规范（Rules）

目标：渐进式开发、随时可运行；优先使用Apple官方/原生 API；按功能分模块，按层分目录，避免“所有代码堆在一个文件”。

## 目录结构

- `Kazeyomi/`（Xcode工程根目录）
  - `Kazeyomi/`（App源码根目录）
    - `App/`：应用入口与全局装配
      - `KazeyomiApp.swift`：`@main`入口（仅负责挂载根视图）
      - `AppRootView.swift`：应用根视图（Tab/导航骨架）
    - `Features/`：按业务域划分的功能模块（feature-first）
      - `Library/`：书库（分类/列表/详情入口）
      - `Browse/`：浏览（来源/扩展/搜索）
      - `Updates/`：更新
      - `History/`：历史
      - `Downloads/`：下载
      - （后续新增：`Reader/`、`Migration/`、`Settings/` 等）
    - `Shared/`：跨模块复用
      - `Components/`：可复用SwiftUI组件（小而清晰）
      - `Networking/`：网络层（URLSession、GraphQL封装、Endpoints等）
      - `Persistence/`：本地持久化（UserDefaults/SwiftData封装）
      - （后续可加：`Models/`、`Utilities/`）

## 文件放置规则

- **UI View（SwiftUI View）**：放在对应 `Features/<FeatureName>/` 下，例如 `Features/Library/LibraryView.swift`。
- **可复用组件**：放在 `Shared/Components/`，例如 `Shared/Components/PlaceholderView.swift`。
- **应用装配与全局入口**：只放在 `App/`。
- **网络层**：放在 `Shared/Networking/`，不要在View里直接拼URL或写请求。
- **持久化与配置**：放在 `Shared/Persistence/`，避免在各处散落UserDefaults key。
- **不要**在 `ContentView.swift` 里堆业务逻辑；它应该只是根视图的别名/薄壳，或被替换为 `AppRootView`。

## 渐进式开发原则

- 每次提交（或阶段）都保证：
  - App可编译、可启动
  - 关键路径（启动 → Tab切换）可验证
- 新功能先做“可跑的骨架”，再填充数据层/API层。

## 技术栈选择（偏开发便利、官方优先）

- UI：SwiftUI
- 状态：优先用SwiftUI/Observation（按项目最低系统版本选择），避免过早引入大型第三方架构
- 网络：优先 `URLSession`；如后续确认Tachidesk GraphQL契约稳定，可再评估Apollo iOS（这一步放到数据层阶段）
- 存储：优先 `UserDefaults`（设置） + `SwiftData`（结构化数据）

## 命名与代码风格

- 类型名用PascalCase，方法/变量用camelCase。
- 文件名与主类型同名（例如 `LibraryView.swift` 内部主类型为 `LibraryView`）。
- 视图尽量保持小（一个视图做一件事），复杂时拆分子View到同目录。
