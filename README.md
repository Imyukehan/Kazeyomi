# Kazeyomi

Kazeyomi 是一个使用 **SwiftUI** 构建的 Tachidesk/Suwayomi 客户端（开发中）。

## 运行环境

- Xcode（建议使用最新稳定版）
- iOS 目标：以项目当前配置为准
- 需要可访问的 Tachidesk/Suwayomi Server（本地或局域网）

## 快速开始

1. 用 Xcode 打开 `Kazeyomi.xcodeproj`
2. 选择 iOS Simulator 或真机运行
3. 在 App 内 `书库 -> 右上角齿轮` 配置 Server：
   - Base URL（例如 `http://127.0.0.1`）
   - 端口（默认 `4567`）
   - 如服务端启用 Basic Auth：打开并填写用户名/密码

## GraphQL（Apollo iOS + Codegen）

本项目 **GraphQL 统一由 Apollo iOS 管理**，并通过 codegen 生成类型安全的 Query/Mutation。

- Schema：`Kazeyomi/Shared/GraphQL/Schema/schema.graphqls`
- Operations：`Kazeyomi/Shared/GraphQL/Operations/*.graphql`
- 生成代码：`Kazeyomi/Shared/GraphQL/Generated/**`
- Codegen 配置：`apollo-codegen-config.json`

### 重新生成代码

仓库内使用本地 Apollo CLI（已放在 `GraphQLCodegen/.local-cli/`）：

```bash
cd /Users/khan/Developer/Swift/Kazeyomi
GraphQLCodegen/.local-cli/apollo-ios-cli generate --path apollo-codegen-config.json --verbose
```

生成文件默认会写入 `Kazeyomi/Shared/GraphQL/Generated/`。

## 目录结构（简版）

- `Kazeyomi/App/`：应用入口与全局装配
- `Kazeyomi/Features/`：按功能划分（Library/Updates/History/…）
- `Kazeyomi/Shared/`：跨模块复用（Components/Models/Networking/Persistence/Utilities）

更详细规范请看 `RULES.md`。

## 提交信息规范（Conventional Commits）

从现在开始建议使用 Conventional Commits，便于回溯与生成变更日志：

- `feat(scope): ...` 新功能
- `fix(scope): ...` 修复 bug
- `docs: ...` 文档/注释
- `refactor(scope): ...` 重构（不改变行为）
- `chore: ...` 杂项（格式化、脚本、依赖、CI 等）

示例：

- `feat(library): add manga detail page`
- `fix(networking): resolve relative image URLs`
- `docs: add README`

> 可选：如果你希望把历史 commit 也统一改成上述格式（重写 commit message，不改代码内容），我可以在确认后帮你完成。注意这会改写 git 历史（适合未 push 或独立分支）。
