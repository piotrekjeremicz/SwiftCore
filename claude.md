# Core Module

Domain-agnostic architecture foundation for the whole ecosystem: DI container, Module/Assembly system, Coordinator-based navigation, and the `@UseCase` macro. Has zero knowledge of transit/GTFS — never add business logic here. Every other module depends on it; it depends on nothing.

## Structure

- `Sources/Core/Dependency/` — DI `Container` + `Resolver`, `@Dependency`/`@LazyDependency` property wrappers, scopes (`.transient`, `.singleton`, `.graph`)
- `Sources/Core/Feature/{Module,Assembly}/` — `Module` and `Assembly` protocols features conform to
- `Sources/Core/Navigation/` — `Coordinator` protocol, `Routable`/`Destinable`/`Presentable`/`Selectable`, `DeeplinkRegistrar`
- `Sources/Core/Abstraction/` — marker protocols (`Service`, `Repository`, `UseCase`, `Store`), all `Sendable`
- `Sources/CoreMacros/` — `@UseCase`/`@UseCaseProtocol`, generate `callAsFunction` from an `execute` method

## Gotchas

- `@Dependency` resolves **immediately** at init. View structs re-init on every render, so a DI-holder class wrapped in `let` re-resolves every render — wrap it in `@State` instead. `@Observable` ViewModels are fine with `let` since their parent's `@State` only inits them once.
- `.destination(navigator:)` uses `.fullScreenCover`; SwiftUI environment does propagate into it, but the `.environment(navigator)` modifier must wrap the same view that carries `.destination`, or `@Environment(...Navigator.self)` resolves to nothing downstream.
- `Assembly` has two registration paths: the typed `registerUseCases`/`registerServices`/`registerRepositories` registrars, and raw `register(in container:)` — use the latter only when you need to resolve and mutate an existing singleton (e.g. registering a widget into `WidgetRegistrar`, see [Common/DesignSystem/claude.md](../../Common/DesignSystem/claude.md)).
