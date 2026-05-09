# Swift App Boilerplate

iOS app boilerplate.

## Status

Early development. Architecture, design system, scaffolding, and reference feature in place — ready to clone and build on.

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
    ├── Tuist/ProjectDescriptionHelpers/        # Tuist compiles all .swift here into one helper module
    │   ├── AppConfig.swift                     # project name, bundle prefix, deployment target
    │   ├── TargetDependency+Named.swift        # .composableArchitecture, .designSystem, etc.
    │   ├── InfoPlist+Default.swift             # InfoPlist.appDefault
    │   ├── FeatureTargetBuilder.swift          # builder + isRoot validation
    │   └── LayerEnforcement.swift              # assertNoRootDependencies free function
    ├── Makefile                    # Common dev commands (default goal: generate)
    ├── scripts/                    # Bootstrap + scaffolding (auto-edit Project.swift)
    ├── App/                        # App target — entry point only
    └── Features/
        ├── AppCoreFeature/         # Root reducer + view (NavigationStack push + sheet @Presents)
        ├── DesignSystem/           # Tokens, asset-catalog colors, button styles, Localizable.strings
        ├── ExampleFeature/         # Reference counter feature, reachable via push and sheet
        └── HapticClient/           # Reference dependency client (Interface/LiveKey/TestKey)
```

## Getting started

```bash
cd app
make setup                       # First-time: install tools, download Tuist, generate
```

After setup, common commands (run from `app/`):

```bash
make                             # Regenerate the Xcode project (default goal)
make edit                        # Open Tuist's manifest editor for live-editing helpers with autocomplete
make test                        # Run all tests
make lint                        # SwiftLint strict check
make format                      # SwiftFormat (2-space indent)
make feature NAME=Settings                       # Scaffold Features/SettingsFeature/ + auto-wire into Project.swift
make feature NAME=Settings WITH_CLIENT=Settings  # Scaffold SettingsFeature + paired SettingsClient, wire the dependency
make client NAME=Auth            # Scaffold Features/AuthClient/ (Interface/LiveKey/TestKey)
make clean                       # Remove generated files
```

## Customize for your app

After cloning, swap in your own values:

- **App icon** — replace `app/App/Resources/Icon.xcassets/AppIcon.appiconset/icon.png` with your own 1024×1024 PNG (square, no rounded corners — iOS applies the mask)
- **Project name + bundle prefix** — edit `app/Tuist/ProjectDescriptionHelpers/AppConfig.swift` (e.g. change `projectName = "App"` and `bundlePrefix = "com.app"` to your reverse-DNS)
- **Brand colors** — edit `app/Features/DesignSystem/Sources/Tokens/DesignColors.swift` (the `Color(hex:)` defaults for `brandPrimary`, `brandPrimaryForeground`)
- **Strings** — edit `app/Features/DesignSystem/Resources/en.lproj/Localizable.strings`; drop in additional `<lang>.lproj/Localizable.strings` for more locales

## Architecture

- **Single TCA project**, all targets live in `Project.swift`
- **Independent design tokens** via separate `EnvironmentValues`: `\.designColors`, `\.designSpacing`, `\.designRadius`, `\.designFonts` — no central `Theme` god-object
- **Semantic colors** via asset catalog (auto-adapt for dark mode + high contrast); brand colors in Swift via `Color(hex:)`
- **Native button style ergonomics**: `.buttonStyle(.primary)` / `.buttonStyle(.secondary)`
- **Dependency clients** follow the `Interface.swift` / `LiveKey.swift` / `TestKey.swift` split (see `HapticClient` for the reference shape) — UIKit confined to `LiveKey.swift` only
- **Navigation patterns** demonstrated end-to-end: `StackState` + `@Reducer enum Path` for push, `@Presents` + `PresentationAction` for modal sheets — see `AppCoreFeature` wired to `ExampleFeature`
- **Root features** (e.g., `AppCoreFeature`) are flagged `isRoot: true` in `Project.swift`; a Tuist manifest validator fails generation if any sibling feature tries to depend on a root
- **Localization centralized** in `DesignSystem/Resources/en.lproj/Localizable.strings` — designed for sync from a translation service (POEditor, Crowdin). Views use Tuist-generated `DesignSystemStrings.<key>` accessors. Add a locale by dropping a `<lang>.lproj/Localizable.strings` next to `en.lproj/`
- **Productized scaffolding** — `make feature` and `make client` auto-edit `Project.swift` between marker comments. No manual paste step

## License

[MIT](./LICENSE) — Copyright (c) 2026 Oleksii Skliarenko
