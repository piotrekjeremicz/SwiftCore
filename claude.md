# Core Module

Foundation framework providing architecture building blocks for the entire About To Go ecosystem.

## Purpose

Core is an **app-agnostic** architectural framework that provides:
- Dependency Injection container
- Module/Assembly system
- Navigation infrastructure (Coordinators, Routing)
- Swift Macros for boilerplate reduction
- Base protocols for application layers

This module has **no knowledge** of transit, GTFS, or any business domain.

## Module Structure

```
Core/
├── Sources/Core/
│   ├── Abstraction/        # Base protocols (Service, Repository, Store, UseCase)
│   ├── App/                # AssembledApp, CoreScene
│   ├── Assembly/           # CoreAssembly
│   ├── Dependency/         # DI Container, Resolver, @Dependency
│   ├── Extensions/         # Utility extensions
│   ├── Feature/
│   │   ├── Assembly/       # Assembly protocol and builders
│   │   └── Module/         # Module protocol and builders
│   └── Navigation/
│       ├── Coordinator/    # Coordinator protocol
│       ├── Deeplink/       # DeeplinkRegistrar
│       └── Navigator/      # Routable, Presentable, Destinable, Selectable
└── Sources/CoreMacros/
    └── UseCase/            # @UseCase, @UseCaseProtocol macros
```

## Key Components

### Dependency Injection

**Container** - Central DI container with scoped registration:

```swift
container.register(MyService.self, scope: .singleton) { resolver in
    MyServiceImpl(dependency: resolver.resolve())
}
```

**Scopes**:
- `.transient` - New instance each resolution (default)
- `.singleton` - Single shared instance
- `.graph` - Shared within resolution graph

**Property Wrappers**:

```swift
@Dependency var service: MyService          // Immediate resolution
@LazyDependency var service: MyService      // Deferred resolution
```

### Module System

**Module Protocol** - Feature entry point:

```swift
public protocol Module {
    associatedtype Factor: Assembly
    @AssemblyBuilder var assemblies: Factor { get }
    func resolve(with container: Container, coordinatorRegistrar: CoordinatorRegistrar)
}
```

**Assembly Protocol** - Dependency registration:

```swift
public protocol Assembly {
    func assemble(container: Container)
    func register(in container: Container)
    func registerStores(in registrar: StoreRegistrar)
    func registerServices(in registrar: ServiceRegistrar)
    func registerRepositories(in registrar: RepositoryRegistrar)
    func registerUseCases(in registrar: UseCaseRegistrar)
    func registerCoordinator(in registrar: CoordinatorRegistrar)
}
```

### AssembledApp

SwiftUI App wrapper that initializes the module system:

```swift
@main
struct MyApp: AssembledApp {
    var scenes: some Scene {
        WindowGroup { RootCoordinator() }
    }

    var modules: some Module {
        CommonModule()
        FeatureModule()
    }
}
```

### Coordinator Pattern

SwiftUI-based navigation coordinator:

```swift
@MainActor
public protocol Coordinator: View {
    associatedtype Root: View
    var root: Root { get }
}

// Default implementation wraps root in NavigationStack
```

### Swift Macros

**@UseCase** - Generates `callAsFunction` from `execute` method:

```swift
@UseCase
struct GetUserUseCase {
    func execute(id: UUID) async throws -> User { ... }
}

// Enables: useCase(id: someId)
```

**@UseCaseProtocol** - Same for protocol definitions.

### Abstraction Protocols

Base marker protocols for architecture layers:

```swift
public protocol Service: Sendable { }
public protocol Repository: Sendable { }
public protocol UseCase: Sendable { }

public protocol Store: Sendable {
    func get<Value>(_ key: String) -> Value?
    func insert<Value>(_ value: Value, at key: String)
    func remove(_ key: String)
}
```

## Navigation Components

### Routable
Type-safe routing for navigation paths.

### Destinable
`.navigationDestination` modifier integration.

### Presentable
Modal presentation with alerts and sheets.

### Selectable
Tab/sidebar selection handling.

## Platform Support

- iOS 26+
- macOS 26+

## Dependencies

- `swift-syntax` (for macros only)

## Usage Guidelines

1. **Never add business logic** to Core - it must remain domain-agnostic
2. **All protocols are Sendable** for strict concurrency
3. **Use result builders** (`@AssemblyBuilder`, `@ModuleBuilder`) for declarative composition
4. **Coordinators are `@MainActor`** as they manage UI
5. **Registrars** (`StoreRegistrar`, `ServiceRegistrar`, etc.) provide type-safe registration

## Extending Core

When adding new architectural concerns:
1. Define the base protocol in `Abstraction/`
2. Create a registrar in `Assembly/` if needed
3. Add registration method to `Assembly` protocol
4. Update `CompactAssembly` if providing a convenience implementation
