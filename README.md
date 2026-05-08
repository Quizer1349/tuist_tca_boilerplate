# Swift App Boilerplate

iOS app boilerplate.

## Status

Early development. Architecture and design system in place; first features in progress.

## Tech stack

- **SwiftUI** + **The Composable Architecture** (TCA) — unidirectional state management
- **Tuist 4.x** — project generation; pinned via `app/.tuist-version`
- **Swift Testing** — unit tests (no XCTest)
- **swift-snapshot-testing** — UI regression tests
- **swift-dependencies** — dependency injection (bundled with TCA)
- **SwiftLintPlugins** + **SwiftFormat** — code style enforcement

iOS 17+ deployment target.

## Repository layout

```
.
├── LICENSE
├── README.md
└── app/                            # Tuist workspace root
    ├── Tuist.swift                 # Tuist version compatibility
    ├── Project.swift               # All targets in one project
    ├── Tuist/Package.swift         # SPM dependencies
    ├── Tuist/ProjectDescriptionHelpers/
    │   └── Project+Templates.swift # FeatureTargetBuilder + layer enforcement
    ├── Makefile                    # Common dev commands (default goal: generate)
    ├── App/                        # App target — entry point only
    └── Features/
        ├── AppCoreFeature/         # Root reducer + view (app-only; flagged isRoot)
        ├── DesignSystem/           # Tokens, semantic colors, button styles, view modifiers
        └── HapticClient/           # Haptic feedback dependency client
```

## Getting started

```bash
cd app
make setup                       # First-time: install tools, download Tuist, generate
```

After setup, common commands (run from `app/`):

```bash
make                             # Regenerate and open the Xcode project (default goal)
make test                        # Run all tests
make lint                        # SwiftLint strict check
make format                      # SwiftFormat (2-space indent)
make feature NAME=Example        # Scaffold Features/ExampleFeature/ with TCA boilerplate
make client NAME=Example         # Scaffold Features/ExampleClient/ (Interface/LiveKey/TestKey)
make clean                       # Remove generated files
```

## Architecture

- **Single TCA project**, all targets live in `Project.swift`
- **Independent design tokens** via separate `EnvironmentValues`: `\.designColors`, `\.designSpacing`, `\.designRadius`, `\.designFonts` — no central `Theme` god-object
- **Semantic colors** via asset catalog (auto-adapt for dark mode + high contrast); brand colors in Swift via `Color(hex:)`
- **Native button style ergonomics**: `.buttonStyle(.primary)` / `.buttonStyle(.secondary)`
- **Dependency clients** follow the `Interface.swift` / `LiveKey.swift` / `TestKey.swift` split (see `HapticClient` for the reference shape) — UIKit confined to `LiveKey.swift` only
- **Root features** (e.g., `AppCoreFeature`) are flagged `isRoot: true` in `Project.swift`; a Tuist manifest validator fails generation if any sibling feature tries to depend on a root

## License

[MIT](./LICENSE) — Copyright (c) 2026 Oleksii Skliarenko
