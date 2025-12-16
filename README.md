# Kazeyomi

Kazeyomi is a Tachidesk/Suwayomi client built with **SwiftUI** (work in progress).

## Requirements

- Xcode (latest stable recommended)
- iOS target: follow the project’s current Xcode settings
- A reachable Tachidesk/Suwayomi Server (local or LAN)

## GraphQL (Apollo iOS + Codegen)

This project uses **Apollo iOS** as the single GraphQL client, with codegen to generate type-safe queries and mutations.

- Schema: `Kazeyomi/Shared/GraphQL/Schema/schema.graphqls`
- Operations: `Kazeyomi/Shared/GraphQL/Operations/*.graphql`
- Generated: `Kazeyomi/Shared/GraphQL/Generated/**`
- Codegen config: `apollo-codegen-config.json`

### Regenerate code

The repo includes a local Apollo CLI binary under `GraphQLCodegen/.local-cli/`:

```bash
cd Kazeyomi
GraphQLCodegen/.local-cli/apollo-ios-cli generate --path apollo-codegen-config.json --verbose
```

Generated files are written to `Kazeyomi/Shared/GraphQL/Generated/`.

## Project structure (simplified)

- `Kazeyomi/App/`: app entry and global wiring
- `Kazeyomi/Features/`: feature modules (Library/Updates/History/…)
- `Kazeyomi/Shared/`: shared code (Components/Models/Networking/Persistence/Utilities)

See `RULES.md` for the full conventions.

## Commit message convention (Conventional Commits)

We follow Conventional Commits from now on for easier history navigation and changelog generation:

- `feat(scope): ...` new feature
- `fix(scope): ...` bug fix
- `docs: ...` documentation
- `refactor(scope): ...` refactor (no behavior change)
- `chore: ...` tooling/formatting/scripts/deps/CI

Examples:

- `feat(library): add manga detail page`
- `fix(networking): resolve relative image URLs`
- `docs: add README`
