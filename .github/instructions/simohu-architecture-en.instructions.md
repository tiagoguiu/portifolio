# Riverpod Rules

## Riverpod 3.0+ Key Changes

### Important Riverpod 3.0 Unification
1. **No more `FamilyNotifier` or `AutoDisposeFamilyAsyncNotifier`**: In Riverpod 3.0, all `FamilyNotifier` and `Notifier` interfaces are unified. Always use the base `Notifier` class regardless of family or auto-dispose configuration.
2. **No more `AutoDisposeNotifier`**: All `AutoDispose*` interfaces are removed. Simply use `Notifier`, `AsyncNotifier`, `StreamNotifier` etc. Auto-dispose is configured via the provider definition (e.g., `NotifierProvider.autoDispose`), not the class interface.
3. **Family providers take constructor parameters**: When using family providers, the Notifier receives the family argument via its constructor, not via a special `build` parameter.

### Using AsyncNotifier with Family (Riverpod 3.0)

When creating a family provider with `AsyncNotifier`, follow this pattern:

```dart
// Provider definition - use .family modifier
final myProvider = AsyncNotifierProvider.autoDispose.family<MyNotifier, Data, int>(
  MyNotifier.new,
);

// Notifier class - extends base AsyncNotifier (not FamilyAsyncNotifier)
class MyNotifier extends AsyncNotifier<Data> {
  // Family argument received via constructor
  MyNotifier(this.arg);
  final int arg;

  @override
  FutureOr<Data> build() async {
    // Use 'arg' directly in build
    return fetchData(arg);
  }
}
```

**Key Points:**
- ✅ Use `AsyncNotifier<Data>` (not `FamilyAsyncNotifier` or `AutoDisposeFamilyAsyncNotifier`)
- ✅ Family argument goes in the constructor
- ✅ `build()` method has no parameters (unlike Riverpod 2.x)
- ✅ Access the family argument via `this.arg` inside `build()`
- ✅ Auto-dispose is configured on the provider, not the class

### Pagination with AsyncNotifier (Recommended Pattern)

For infinite scroll/pagination with family providers:

```dart
final paginatedDataProvider = AsyncNotifierProvider.autoDispose.family<
  PaginatedDataNotifier,
  List<Item>,
  int
>(PaginatedDataNotifier.new);

class PaginatedDataNotifier extends AsyncNotifier<List<Item>> {
  PaginatedDataNotifier(this.categoryId);
  final int categoryId;

  // Internal flag to track pagination state (NOT a separate provider)
  bool _hasMorePages = true;
  bool get hasMorePages => _hasMorePages;

  @override
  FutureOr<List<Item>> build() async {
    final filter = ref.watch(filterProvider);
    
    // Fetch from API
    final paginatedResponse = await repository.fetchItems(
      categoryId,
      page: filter.page,
      perPage: filter.perPage,
    );

    // Update hasMorePages based on API response
    _hasMorePages = !paginatedResponse.lastPage;

    // First page: return fresh data
    if (filter.page == 1) {
      return paginatedResponse.items;
    }

    // Subsequent pages: append to existing data and deduplicate
    final previousItems = state.value ?? [];
    final Map<int, Item> uniqueItems = {for (final item in previousItems) item.id: item};
    for (final item in paginatedResponse.items) {
      uniqueItems[item.id] = item;
    }

    return uniqueItems.values.toList();
  }
}

// IMPORTANT: Filter provider should NOT use autoDispose to persist state
final filterProvider = NotifierProvider<FilterNotifier, FilterState>(
  FilterNotifier.new,
);

// Helper to load more (check loading state AND hasMorePages via notifier)
Future<void> loadMore(WidgetRef ref, int categoryId) async {
  final current = ref.read(paginatedDataProvider(categoryId));
  if (current.isLoading) return; // Prevent multiple calls
  
  final notifier = ref.read(paginatedDataProvider(categoryId).notifier);
  if (!notifier.hasMorePages) return; // No more pages
  
  ref.read(filterProvider.notifier).nextPage();
}
```

**Key Points for Pagination:**
- ✅ Use internal `_hasMorePages` flag in the Notifier (NOT a separate provider)
- ✅ Access `hasMorePages` via `notifier.hasMorePages` in `loadMore`
- ✅ Filter provider should NOT use `autoDispose` to persist pagination state
- ✅ Always check `current.isLoading` before calling `nextPage()`
- ✅ Deduplicate items when appending to prevent duplicates

### Using Ref in Riverpod
1. The `Ref` object is essential for accessing the provider system, reading or watching other providers, managing lifecycles, and handling dependencies in Riverpod.
2. In functional providers, obtain `Ref` as a parameter; in class-based providers, access it as a property of the Notifier.
3. In widgets, use `WidgetRef` (a subtype of `Ref`) to interact with providers.
4. The `@riverpod` annotation is used to define providers with code generation, where the function receives `ref` as its parameter.
5. Use `ref.watch` to reactively listen to other providers; use `ref.read` for one-time access (non-reactive); use `ref.listen` for imperative subscriptions; use `ref.onDispose` to clean up resources.
6. Example: Functional provider with Ref
   ```dart
   final otherProvider = Provider<int>((ref) => 0);
   final provider = Provider<int>((ref) {
     final value = ref.watch(otherProvider);
     return value * 2;
   });
   ```
7. Example: Provider with @riverpod annotation
   ```dart
   @riverpod
   int example(ref) {
     return 0;
   }
   ```
8. Example: Using Ref for cleanup
   ```dart
   final provider = StreamProvider<int>((ref) {
     final controller = StreamController<int>();
     ref.onDispose(controller.close);
     return controller.stream;
   });
   ```
9. Example: Using WidgetRef in a widget
   ```dart
   class MyWidget extends ConsumerWidget {
     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final value = ref.watch(myProvider);
       return Text('$value');
     }
   }
   ```

### Combining Requests
1. Use the `Ref` object to combine providers and requests; all providers have access to a `Ref`.
2. In functional providers, obtain `Ref` as a parameter; in class-based providers, access it as a property of the Notifier.
3. Prefer using `ref.watch` to combine requests, as it enables reactive and declarative logic that automatically recomputes when dependencies change.
4. When using `ref.watch` with asynchronous providers, use `.future` to await the value if you need the resolved result, otherwise you will receive an `AsyncValue`.
5. Avoid calling `ref.watch` inside imperative code (e.g., listener callbacks or Notifier methods); only use it during the build phase of the provider.
6. Use `ref.listen` as an alternative to `ref.watch` for imperative subscriptions, but prefer `ref.watch` for most cases as `ref.listen` is more error-prone.
7. It is safe to use `ref.listen` during the build phase; listeners are automatically cleaned up when the provider is recomputed.
8. Use the return value of `ref.listen` to manually remove listeners when needed.
9. Use `ref.read` only when you cannot use `ref.watch`, such as inside Notifier methods; `ref.read` does not listen to provider changes.
10. Be cautious with `ref.read`, as providers not being listened to may destroy their state if not actively watched.

### Auto Dispose & State Disposal
1. By default, with code generation, provider state is destroyed when the provider stops being listened to for a full frame.
2. Opt out of automatic disposal by setting `keepAlive: true` (codegen) or using `ref.keepAlive()` (manual).
3. When not using code generation, state is not destroyed by default; enable `.autoDispose` on providers to activate automatic disposal.
4. Always enable automatic disposal for providers that receive parameters to prevent memory leaks from unused parameter combinations.
5. State is always destroyed when a provider is recomputed, regardless of auto dispose settings.
6. Use `ref.onDispose` to register cleanup logic that runs when provider state is destroyed; do not trigger side effects or modify providers inside `onDispose`.
7. Use `ref.onCancel` to react when the last listener is removed, and `ref.onResume` when a new listener is added after cancellation.
8. Call `ref.onDispose` multiple times if needed—once per disposable object—to ensure all resources are cleaned up.
9. Use `ref.invalidate` to manually force the destruction of a provider's state; if the provider is still listened to, a new state will be created.
10. Use `ref.invalidateSelf` inside a provider to force its own destruction and immediate recreation.
11. When invalidating parameterized providers, you can invalidate a specific parameter or all parameter combinations.
12. Use `ref.keepAlive` for fine-tuned control over state disposal; revert to automatic disposal using the return value of `ref.keepAlive`.
13. To keep provider state alive for a specific duration, combine a `Timer` with `ref.keepAlive` and dispose after the timer completes.
14. Consider using `ref.onCancel` and `ref.onResume` to implement custom disposal strategies, such as delayed disposal after a provider is no longer listened to.

### Eager Initialization
1. Providers are initialized lazily by default; they are only created when first used.
2. There is no built-in way to mark a provider for eager initialization due to Dart's tree shaking.
3. To eagerly initialize a provider, explicitly read or watch it at the root of your application (e.g., in a `Consumer` placed directly under `ProviderScope`).
4. Place the eager initialization logic in a public widget (such as `MyApp`) rather than in `main()` to ensure consistent test behavior.
5. Eagerly initializing a provider in a dedicated widget will not cause your entire app to rebuild when the provider changes; only the initialization widget will rebuild.
6. Handle loading and error states for eagerly initialized providers as you would in any `Consumer`, e.g., by returning a loading indicator or error widget.
7. Use `AsyncValue.requireValue` in widgets to read the data directly and throw a clear exception if the value is not ready, instead of handling loading/error states everywhere.
8. Avoid creating multiple providers or using overrides solely to hide loading/error states; this adds unnecessary complexity and is discouraged.

### First Provider & Network Requests
1. Always wrap your app with `ProviderScope` at the root (directly in `runApp`) to enable Riverpod for the entire application.
2. Place business logic such as network requests inside providers; use `Provider`, `FutureProvider`, or `StreamProvider` depending on the return type.
3. Providers are lazy—network requests or logic inside a provider are only executed when the provider is first read.
4. Define provider variables as `final` and at the top level (global scope).
5. Use code generators like Freezed or json_serializable for models and JSON parsing to reduce boilerplate.
6. Use `Consumer` or `ConsumerWidget` in your UI to access providers via a `ref` object.
7. Handle loading and error states in the UI by using the `AsyncValue` API returned by `FutureProvider` and `StreamProvider`.
8. Multiple widgets can listen to the same provider; the provider will only execute once and cache the result.
9. Use `ConsumerWidget` or `ConsumerStatefulWidget` to reduce code indentation and improve readability over using a `Consumer` widget inside a regular widget.
10. To use both hooks and providers in the same widget, use `HookConsumerWidget` or `StatefulHookConsumerWidget` from `flutter_hooks` and `hooks_riverpod`.
11. Always install and use `riverpod_lint` to enable IDE refactoring and enforce best practices.
12. Do not put `ProviderScope` inside `MyApp`; it must be the top-level widget passed to `runApp`.
13. When handling network requests, always render loading and error states gracefully in the UI.
14. Do not re-execute network requests on widget rebuilds; Riverpod ensures the provider is only executed once unless explicitly invalidated.

### Passing Arguments to Providers
1. Use provider "families" to pass arguments to providers; add `.family` after the provider type and specify the argument type.
2. When using code generation, add parameters directly to the annotated function (excluding `ref`).
3. Always enable `autoDispose` for providers that receive parameters to avoid memory leaks.
4. When consuming a provider that takes arguments, call it as a function with the desired parameters (e.g., `ref.watch(myProvider(param))`).
5. You can listen to the same provider with different arguments simultaneously; each argument combination is cached separately.
6. The equality (`==`) of provider parameters determines caching—ensure parameters have consistent and correct equality semantics.
7. Avoid passing objects that do not override `==` (such as plain `List` or `Map`) as provider parameters; use `const` collections, custom classes with proper equality, or Dart 3 records.
8. Use the `provider_parameters` lint rule from `riverpod_lint` to catch mistakes with parameter equality.
9. For multiple parameters, prefer code generation or Dart 3 records, as records naturally override `==` and are convenient for grouping arguments.
10. If two widgets consume the same provider with the same parameters, only one computation/network request is made; with different parameters, each is cached separately.

### FAQ & Best Practices
1. Use `ref.refresh(provider)` when you want to both invalidate a provider and immediately read its new value; use `ref.invalidate(provider)` if you only want to invalidate without reading the value.
2. Always use the return value of `ref.refresh`; ignoring it will trigger a lint warning.
3. If a provider is invalidated while not being listened to, it will not update until it is listened to again.
4. Do not try to share logic between `Ref` and `WidgetRef`; move shared logic into a `Notifier` and call methods on the notifier via `ref.read(yourNotifierProvider.notifier).yourMethod()`.
5. Prefer `Ref` for business logic and avoid relying on `WidgetRef`, which ties logic to the UI layer.
6. Extend `ConsumerWidget` instead of using raw `StatelessWidget` when you need access to providers in the widget tree, due to limitations of `InheritedWidget`.
7. `InheritedWidget` cannot implement a reliable "on change" listener or track when widgets stop listening, which is required for Riverpod's advanced features.
8. Do not expect to reset all providers at once; instead, make providers that should reset depend on a "user" or "session" provider and reset that dependency.
9. `hooks_riverpod` and `flutter_hooks` are versioned independently; always add both as dependencies if using hooks.
10. Riverpod uses `identical` instead of `==` to filter updates for performance reasons, especially with code-generated models; override `updateShouldNotify` on Notifiers to change this behavior.
11. If you encounter "Using `ref` when a widget is about to or has been unmounted is unsafe" after the widget was disposed, ensure you check `context.mounted` before using `ref` after an `await` in an async callback.

### Provider Observers (Logging & Error Reporting)
1. Use a `ProviderObserver` to listen to all events in the provider tree for logging, analytics, or error reporting.
2. Extend the `ProviderObserver` class and override its methods to respond to provider lifecycle events:
   - `didAddProvider(ProviderObserverContext context, Object? value)`: called when a provider is added to the tree.
   - `didUpdateProvider(ProviderObserverContext context, Object? previousValue, Object? newValue)`: called when a provider is updated.
   - `didDisposeProvider(ProviderObserverContext context)`: called when a provider is disposed.
   - `providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace)`: called when a synchronous provider throws an error.
3. Register your observer(s) by passing them to the `observers` parameter of `ProviderScope` (for Flutter apps) or `ProviderContainer` (for pure Dart).
4. You can register multiple observers if needed by providing a list to the `observers` parameter.
5. Use observers to integrate with remote error reporting services, log provider state changes, or trigger custom analytics.

### Performing Side Effects
1. Use Notifiers (`Notifier`, `AsyncNotifier`, etc.) to expose methods for performing side effects (e.g., POST, PUT, DELETE) and modifying provider state.
2. Always define provider variables as `final` and at the top level (global scope).
3. Choose the provider type (`NotifierProvider`, `AsyncNotifierProvider`, etc.) based on the return type of your logic.
4. Use provider modifiers like `autoDispose` and `family` as needed for cache management and parameterization.
5. Expose public methods on Notifiers for UI to trigger state changes or side effects.
6. In UI event handlers (e.g., button `onPressed`), use `ref.read` to call Notifier methods; avoid using `ref.watch` for imperative actions.
7. After performing a side effect, update the UI state by:
   - Setting the new state directly if the server returns the updated data.
   - Calling `ref.invalidateSelf()` to refresh the provider and re-fetch data.
   - Manually updating the local cache if the server does not return the new state.
8. When updating the local cache, prefer immutable state, but mutable state is possible if necessary.
9. Always handle loading and error states in the UI when performing side effects.
10. Use progress indicators and error messages to provide feedback for pending or failed operations.
11. Be aware of the pros and cons of each update approach:
    - Direct state update: most up-to-date but depends on server implementation.
    - Invalidate and refetch: always consistent with server, but may incur extra network requests.
    - Manual cache update: efficient, but risks state divergence from server.
12. Use hooks (`flutter_hooks`) or `StatefulWidget` to manage local state (e.g., pending futures) for showing spinners or error UI during side effects.
13. Do not perform side effects directly inside provider constructors or build methods; expose them via Notifier methods and invoke from the UI layer.

### Testing Providers
1. Always create a new `ProviderContainer` (unit tests) or `ProviderScope` (widget tests) for each test to avoid shared state between tests. Use a utility like `createContainer()` to set up and automatically dispose containers (see `/references/riverpod/testing/create_container.dart`).
2. In unit tests, never share `ProviderContainer` instances between tests. Example:
   ```dart
   final container = createContainer();
   expect(container.read(provider), equals('some value'));
   ```
3. In widget tests, always wrap your widget tree with `ProviderScope` when using `tester.pumpWidget`. Example:
   ```dart
   await tester.pumpWidget(
     const ProviderScope(child: YourWidgetYouWantToTest()),
   );
   ```
4. Obtain a `ProviderContainer` in widget tests using `ProviderScope.containerOf(BuildContext)`. Example:
   ```dart
   final element = tester.element(find.byType(YourWidgetYouWantToTest));
   final container = ProviderScope.containerOf(element);
   ```
5. After obtaining the container, you can read or interact with providers as needed for assertions. Example:
   ```dart
   expect(container.read(provider), 'some value');
   ```
6. For providers with `autoDispose`, prefer `container.listen` over `container.read` to prevent the provider's state from being disposed during the test.
7. Use `container.read` to read provider values and `container.listen` to listen to provider changes in tests.
8. Use the `overrides` parameter on `ProviderScope` or `ProviderContainer` to inject mocks or fakes for providers in your tests.
9. Use `container.listen` to spy on changes in a provider for assertions or to combine with mocking libraries.
10. Await asynchronous providers in tests by reading the `.future` property (for `FutureProvider`) or listening to streams.
11. Prefer mocking dependencies (such as repositories) used by Notifiers rather than mocking Notifiers directly.
12. If you must mock a Notifier, subclass the original Notifier base class instead of using `implements` or `with Mock`.
13. Place Notifier mocks in the same file as the Notifier being mocked if code generation is used, to access generated classes.
14. Use the `overrides` parameter to swap out Notifiers or providers for mocks or fakes in tests.
15. Keep all test-specific setup and teardown logic inside the test body or test utility functions. Avoid global state.
16. Ensure your test environment closely matches your production environment for reliable results.

# Simohu App Architecture Instructions (English)

This document defines the architectural rules and project-specific patterns for the Simohu app. All new features and modifications must follow these guidelines.

## 1. Layered Architecture (Clean Architecture)

The project follows Clean Architecture with strict separation of responsibilities:

```
lib/
├── data/           # Data Layer
│   ├── models/     # Data Models (DTOs)
│   ├── data/       # Data Sources
│   ├── interfaces/ # Repository contracts
│   └── repository/ # Repository implementations
├── domain/         # Domain Layer
│   ├── entity/     # Domain entities
│   ├── usecases/   # Use cases
│   └── logics/     # Validators and helpers
└── presentation/   # Presentation Layer
    ├── widgets/    # UI components
    └── state/      # State management (Riverpod)
```

### 1.1. Data Layer

Responsibilities:
- Communicate with external APIs
- JSON (de)serialization
- Firebase and external services access
- Local cache

Rules:
- ✅ DataModels must remain ONLY in the data layer
- ✅ Use the `DataModel` suffix (e.g., `AddressDataModel`, `CompaniesDataModel`)
- ✅ Implement `fromJson` and `toJson` for serialization
- ✅ Keep field names identical to the upstream API (e.g., `logradouro`, `localidade`)
- ✅ Use `ApiRoutes` class for all API path definitions.
- ❌ NEVER expose DataModels to the domain or presentation layers

Example - Data Source:
```dart
class _AuthRemoteDataSource implements AuthRepository {
  @override
  Future<AddressDataModel?> fetchAddressByCep(String cep) async {
    final cleanCep = cep.replaceAll('-', '');
    final response = await ApiService.request<AddressDataModel>(
      url: ApiRoutes.viacepPath(cleanCep),
      method: HttpMethod.get,
      isAuthenticated: false,
      fromJson: (data) => AddressDataModel.fromJson(data as Map<String, dynamic>),
    );
    return response.data;
  }
}
```

Example - DataModel:
```dart
/// Address data model - used only in the data layer
class AddressDataModel {
  final String cep;
  final String logradouro;  // Original API field name
  final String bairro;
  final String localidade;
  final String uf;

  AddressDataModel({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory AddressDataModel.fromJson(Map<String, dynamic> json) => AddressDataModel(
    cep: json['cep'] ?? '',
    logradouro: json['logradouro'] ?? '',
    bairro: json['bairro'] ?? '',
    localidade: json['localidade'] ?? '',
    uf: json['uf'] ?? '',
  );
}
```

### 1.2. Domain Layer

Responsibilities:
- Define business entities
- Implement business rules
- Convert DataModels to Entities
- Orchestrate complex flows

Rules:
- ✅ Entities should use domain-friendly English names (e.g., `street` instead of `logradouro`)
- ✅ Use the `Entity` suffix (e.g., `AddressEntity`, `CompaniesEntity`)
- ✅ Conversion DataModel → Entity MUST happen in the UseCase
- ✅ Entities can have a factory `fromDataModel()`
- ❌ NEVER perform conversion in Repositories or DataSources
- ❌ NEVER import DataModels in presentation

Example - Entity:
```dart
/// Address entity - used in the domain layer
class AddressEntity {
  final String cep;
  final String street;        // Domain name
  final String neighborhood;
  final String city;
  final String state;

  const AddressEntity({
    required this.cep,
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  factory AddressEntity.fromDataModel(AddressDataModel dataModel) => AddressEntity(
    cep: dataModel.cep,
    street: dataModel.logradouro,      // Mapping here
    neighborhood: dataModel.bairro,
    city: dataModel.localidade,
    state: dataModel.uf,
  );
}
```

Example - UseCase:
```dart
class _RegisterUserCase implements RegisterUserCase {
  _RegisterUserCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<AddressEntity?> fetchAddressByCep(String cep) async {
    // Repository returns DataModel
    final dataModel = await _auth_repository.fetchAddressByCep(cep);

    // UseCase converts to Entity before returning
    return dataModel != null ? AddressEntity.fromDataModel(dataModel) : null;
  }

  @override
  Stream<List<CompaniesEntity>> getCompaniesList() =>
    _auth_repository.getCompaniesList().map(
      (dataModels) => dataModels
        .map((dataModel) => CompaniesEntity.fromDataModel(dataModel))
        .toList(),
    );
}
```

### 1.3. Presentation Layer

Responsibilities:
- Build user interface
- Manage ephemeral state
- React to state changes
- Validate user input

Rules:
- ✅ Use `ConsumerWidget` for pages and widgets. Avoid `ConsumerStatefulWidget` unless absolutely necessary (e.g., for `initState` logic that cannot be handled by a provider).
- ✅ Use ONLY Entities, NEVER DataModels
- ✅ Consume UseCases through Riverpod Providers
- ✅ Manage form state and page state with `Notifier` or `AsyncNotifier`.
- ✅ Use `ValueKey` to force rebuild on fields with `initialValue`
- ❌ NEVER call Repositories directly from UI
- ❌ NEVER import or use DataModels in presentation

## 2. External API Integration Pattern

For every third-party API integration, strictly follow this flow:

### 2.1. Step 1 - Create DataModel (Data Layer)

```dart
// lib/data/models/[feature]/[name]_data_model.dart
class FeatureDataModel {
  final String apiFieldName;  // Exact field name from the API

  factory FeatureDataModel.fromJson(Map<String, dynamic> json) => 
    FeatureDataModel(apiFieldName: json['api_field_name'] ?? '');
}
```

### 2.2. Step 2 - Add a method in the DataSource

```dart
// lib/data/data/[feature]_data_source.dart
class _FeatureDataSource implements FeatureRepository {
  @override
  Future<FeatureDataModel?> fetchData() async {
    final response = await ApiService.request<FeatureDataModel>(
      url: ApiRoutes.endpoint,
      method: HttpMethod.get,
      fromJson: (data) => FeatureDataModel.fromJson(data),
    );
    return response.data;
  }
}
```

### 2.3. Step 3 - Add interface and repository implementation

```dart
// lib/data/interfaces/[feature]_interface.dart
abstract interface class FeatureRepository {
  Future<FeatureDataModel?> fetchData();
}

// lib/data/repository/[feature]_repository.dart
class _FeatureRepositoryImpl implements FeatureRepository {
  @override
  Future<FeatureDataModel?> fetchData() =>
    _dataSource.fetchData(); // Delegate to DataSource
}
```

### 2.4. Step 4 - Create Entity (Domain Layer)

```dart
// lib/domain/entity/[feature]/feature_entity.dart
class FeatureEntity {
  final String domainFieldName;  // Domain friendly name (English)

  factory FeatureEntity.fromDataModel(FeatureDataModel dataModel) =>
    FeatureEntity(domainFieldName: dataModel.apiFieldName);
}
```

### 2.5. Step 5 - Implement UseCase with conversion

```dart
// lib/domain/usecases/[feature]_usecase.dart
class _FeatureUseCase implements FeatureUseCase {
  @override
  Future<FeatureEntity?> fetchData() async {
    final dataModel = await _repository.fetchData();
    return dataModel != null 
      ? FeatureEntity.fromDataModel(dataModel) 
      : null;
  }
}
```

### 2.6. Step 6 - Consume from Widgets via Provider

```dart
// lib/presentation/[feature]/widgets/feature_widget.dart
class FeatureWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(featureProvider);
    // Use only Entity properties, never DataModel ones
    return Text(data.domainFieldName);
  }
}
```

## 3. State Management with Riverpod 3.0

### 3.1. Providers

Rules:
- ✅ Use `NotifierProvider` for mutable state
- ✅ Use `StreamProvider` for real-time data
- ✅ ALWAYS use `autoDispose` by default (frees resources)
- ⚠️ Remove `autoDispose` ONLY for cached data that should persist (e.g., company lists, global settings)
- ✅ Use `AsyncNotifierProvider` for asynchronous operations

When to use `autoDispose`:
- ✅ Forms (temporary data)
- ✅ Page-local state
- ✅ Local loading states
- ✅ One-off CRUD operations

When NOT to use `autoDispose`:
- ❌ Reference lists (companies, categories)
- ❌ Global configuration
- ❌ Shared real-time streams

Example - StreamProvider without autoDispose (special case):
```dart
// ❌ WRONG - causes multiple calls
final companiesProvider = StreamProvider.autoDispose<List<CompaniesEntity>>(
  (ref) => ref.watch(useCase).getCompaniesList(),
);

// ✅ CORRECT - keeps cache
final companiesProvider = StreamProvider<List<CompaniesEntity>>(
  (ref) => ref.watch(useCase).getCompaniesList(),
);
```

### 3.2. Notifiers for Forms

Rules:
- ✅ Create an immutable model for the form data
- ✅ Each field has a dedicated `update` method
- ✅ Use `copyWith` to update state
- ✅ Provide a `reset()` method to clear the form

Example:
```dart
// Form model
class RegisterFormData {
  final String name;
  final String email;
  const RegisterFormData({this.name = '', this.email = ''});

  RegisterFormData copyWith({String? name, String? email}) =>
    RegisterFormData(name: name ?? this.name, email: email ?? this.email);
}

// Notifier
class RegisterFormDataNotifier extends Notifier<RegisterFormData> {
  @override
  RegisterFormData build() => const RegisterFormData();

  void updateName(String name) => state = state.copyWith(name: name);
  void updateEmail(String email) => state = state.copyWith(email: email);
  void reset() => state = const RegisterFormData();
}

// Provider
final registerFormProvider = NotifierProvider.autoDispose<
  RegisterFormDataNotifier,
  RegisterFormData
>(RegisterFormDataNotifier.new);
```

## 4. Form Patterns

### 4.1. Hybrid Approach (RECOMMENDED)

Use:
- `TextEditingController` for fields that require `inputFormatter`
- `initialValue` + `onChanged` for simple text fields

Rules:
- ✅ Controllers required for: CPF, phone, CEP, date
- ✅ `initialValue` for: name, email, plain text fields
- ✅ Add `ValueKey` to fields auto-filled by API
- ✅ Add listeners to controllers for automatic actions (e.g., fetch CEP)

Example - field with InputFormatter:
```dart
class _FormState extends ConsumerState<FormWidget> {
  late final TextEditingController cepController;

  @override
  void initState() {
    super.initState();
    final data = ref.read(formProvider);
    cepController = TextEditingController(text: data.cep);
    cepController.addListener(_onCepChanged);
  }

  @override
  void dispose() {
    cepController.removeListener(_onCepChanged);
    cepController.dispose();
    super.dispose();
  }

  Future<void> _onCepChanged() async {
    final cep = cepController.text.replaceAll('-', '');
    if (cep.length == 8) {
      // Fetch address by CEP
      final address = await ref.read(useCase).fetchAddress(cep);
      if (address != null) {
        ref.read(formProvider.notifier).updateStreet(address.street);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      fieldController: cepController,
      inputFormatters: [CepInputFormatter()],
      label: 'CEP',
    );
  }
}
```

Example - simple field:
```dart
@override
Widget build(BuildContext context) {
  final formData = ref.watch(formProvider);

  return AppTextFormField(
    initialValue: formData.name,
    onChanged: ref.read(formProvider.notifier).updateName,
    label: 'Name',
  );
}
```

### 4.2. Auto-filled Fields (ValueKey)

Problem: fields with `initialValue` do not update when Riverpod state changes.

Solution: add a `ValueKey` based on the field value to force a rebuild.

```dart
@override
Widget build(BuildContext context) {
  final addressData = ref.watch(addressProvider);

  return Column(
    children: [
      AppTextFormField(
        key: ValueKey('street_${addressData.street}'),  // forces rebuild
        initialValue: addressData.street,
        onChanged: ref.read(addressProvider.notifier).updateStreet,
        label: 'Street',
      ),
      AppTextFormField(
        key: ValueKey('city_${addressData.city}'),
        initialValue: addressData.city,
        onChanged: ref.read(addressProvider.notifier).updateCity,
        label: 'City',
      ),
    ],
  );
}
```

## 5. Review of Implemented Features (examples)

... (omitted for brevity in this English companion; keep the Portuguese master file as authoritative) ...

## 6. Checklist for integrating a new API

Follow these steps when adding a new external API (short summary):
- Create DataModel in `lib/data/models/[feature]`
- Add DataSource method that returns DataModel
- Add Repository contract and implementation delegating to DataSource
- Create Entity in `lib/domain/entity/[feature]`
- Convert DataModel → Entity in the UseCase
- Expose data to UI via Providers (UseCases → Providers → Widgets)

## 7. Naming Conventions

File names:
- DataModels: `[name]_data_model.dart`
- Entities: `[name]_entity.dart`
- UseCases: `[feature]_usecase.dart`
- Repositories: `[feature]_repository.dart`
- DataSources: `[feature]_data_source.dart`

Class names:
- DataModels: `[Name]DataModel`
- Entities: `[Name]Entity`
- UseCases: `[Feature]UseCase` (interface), `_[Feature]UseCase` (implementation)
- Repositories: `[Feature]Repository` (interface), `_[Feature]Repository` (implementation)
- Notifiers: `[Feature]Notifier`

Providers:
- UseCase providers: `[feature]UseCaseProvider`
- Repository providers: `[feature]RepositoryProvider`
- State providers: `[feature]StateProvider`
- Data providers: `[feature]DataProvider`

## 8. Anti-patterns (What NOT to do)

- ❌ NEVER use a DataModel outside the data layer
- ❌ NEVER convert DataModels in the Repository
- ❌ NEVER call Repositories from the UI (always go through UseCases)
- ❌ NEVER use `autoDispose` for cached data that must persist
- ❌ NEVER rely on `initialValue` updating without `ValueKey` for auto-filled fields

## 9. Visual Architecture Diagram

```
PRESENTATION LAYER
 Widgets  | Riverpod | Entities
    ↓        ↓        ↓
 UseCase (Domain) -> Converts DataModel to Entity
    ↓
 DATA LAYER
 DataSource (API) -> Repository (delegate) -> DataModel
```

## 10. Project Structure and File Locations

Understanding where files are located helps maintain consistency:

### API Configuration
- **Location:** `lib/common/api_config/`
- **Contents:** All API-related files including routes, service, interceptors, error handling, and WebSocket
- **Files:**
  - `api_routes.dart` - API endpoint definitions
  - `api_service.dart` - HTTP request handler (GET, POST, PATCH, DELETE, PUT)
  - `api_interceptor.dart` - Request/response interceptors
  - `api_error.dart` - Error models
  - `api_response.dart` - Response wrapper
  - `web_socket_service.dart` - WebSocket connections

### Routing
- **Location:** `lib/common/routing/`
- **Contents:** All navigation and routing configuration
- **Files:**
  - `router_config.dart` - GoRouter configuration
  - `route_names.dart` - Route name constants
  - `auth_change_provider.dart` - Authentication state provider

### Common Widgets
- **Location:** `lib/common/widgets/`
- **Contents:** Reusable UI components
- **Key widgets:**
  - `page_scaffold.dart` - `CommonPageScaffold` widget (standard page wrapper)
  - Form inputs, buttons, dialogs, etc.

### Local Storage
- **Location:** `lib/common/local_storage/`
- **Contents:** Local data persistence and caching

### Theme
- **Location:** `lib/common/theme/`
- **Contents:** App theming, colors, text styles

### Data Layer
- **Models:** `lib/data/models/[feature]/` - DataModels organized by feature
- **Data Sources:** `lib/data/data/` - API data sources
- **Repositories:** `lib/data/repository/` - Repository implementations
- **Interfaces:** `lib/data/interfaces/` - Repository contracts

### Domain Layer
- **Entities:** `lib/domain/entity/[feature]/` - Domain entities by feature
- **Use Cases:** `lib/domain/usecases/` - Business logic use cases
- **Validators:** `lib/domain/logics/` - Validation logic and helpers

### Presentation Layer
- **Pages:** `lib/presentation/[feature]/pages/` - Feature pages
- **Widgets:** `lib/presentation/[feature]/widgets/` - Feature-specific widgets
- **State:** `lib/presentation/[feature]/state/` - Riverpod providers and notifiers

## 11. UI Best Practices

### 11.1. Use CommonPageScaffold

**Location:** `lib/common/widgets/page_scaffold.dart`

For most pages, use `CommonPageScaffold` instead of raw `Scaffold` to maintain consistency:

```dart
return CommonPageScaffold(
  title: 'Page Title',
  automaticallyImplyLeading: true,  // Show back button
  centerTitle: true,
  withPadding: true,  // Adds horizontal padding (24.width)
  actions: [IconButton(...)],
  child: YourContent(),
);
```

**When to use:**
- ✅ Standard pages with AppBar
- ✅ Forms and content pages
- ✅ List views

**When NOT to use:**
- ❌ Custom layouts (onboarding, splash)
- ❌ Pages requiring full-screen design
- ❌ Bottom sheets or dialogs

### 11.2. Responsive Layout Best Practices

Follow Flutter's adaptive design guidelines from Flutter Docs: <https://docs.flutter.dev/ui/adaptive-responsive/best-practices>

#### **Use MediaQuery.sizeOf() and LayoutBuilder**

**DON'T** check device types or orientation directly:
```dart
// ❌ WRONG - Assumes device type
if (Platform.isAndroid) { ... }

// ❌ WRONG - Uses device orientation
if (MediaQuery.of(context).orientation == Orientation.portrait) { ... }
```

**DO** use available space to make layout decisions:
```dart
// ✅ CORRECT - Responds to actual space
Widget build(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  final width = size.width;
  
  if (width > 600) {
    return TabletLayout();
  }
  return MobileLayout();
}

// ✅ CORRECT - LayoutBuilder for widget-specific space
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 800) {
      return WideLayout();
    }
    return NarrowLayout();
  },
)
```

#### **Use .width and .height Extension Methods Carefully**

The project uses responsive extension methods (e.g., `24.width`, `16.height`) for spacing:

**DO:**
- ✅ Use for padding, margins, and spacing
- ✅ Use with `ConstrainedBox` for max widths
- ✅ Combine with `MediaQuery.sizeOf()` for breakpoints

```dart
// ✅ CORRECT - Responsive padding
Padding(
  padding: EdgeInsets.symmetric(horizontal: 24.width),
  child: content,
)

// ✅ CORRECT - Max width constraint
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: 400),
  child: Form(...),
)
```

**DON'T:**
- ❌ Lock content to full screen width on large screens
- ❌ Use orientation checks for layout decisions
- ❌ Assume specific device dimensions

```dart
// ❌ WRONG - Takes full width on large screens
Container(
  width: MediaQuery.sizeOf(context).width,
  child: TextField(),
)

// ✅ CORRECT - Constrains maximum width
Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 600),
    child: TextField(),
  ),
)
```

#### **Break Down Large Widgets**

```dart
// ✅ CORRECT - Small, reusable widgets
class _FormSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      _HeaderWidget(),
      _FormFields(),
      _SubmitButton(),
    ],
  );
}
```

#### **Support Multiple Input Devices**

Material widgets handle touch, mouse, and keyboard by default. For custom widgets:
- ✅ Add keyboard shortcuts for common actions
- ✅ Support mouse hover states
- ✅ Ensure touch targets are at least 48x48 logical pixels

#### **Don't Lock Orientation**

- ✅ Support both portrait and landscape
- ✅ Use `MediaQuery.sizeOf()` instead of checking orientation
- ✅ Test your UI in different aspect ratios

#### **Save and Restore State**

- ✅ Use `PageStorageKey` for scroll positions
- ✅ Persist form data with Riverpod
- ✅ Handle configuration changes gracefully

### 11.3. Layout Widgets and Patterns

Understanding Flutter's layout system is essential for building dynamic UIs. Reference: Flutter Layout Documentation — `https://docs.flutter.dev/ui/layout`

#### **Core Layout Widgets**

**Row and Column:**
- `Row` arranges widgets horizontally
- `Column` arranges widgets vertically
- Both accept a list of children widgets
- Use `mainAxisAlignment` and `crossAxisAlignment` for alignment
- Can nest rows and columns for complex layouts

```dart
// ✅ Row with aligned children
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Icon(Icons.star),
    Text('Rating'),
    Icon(Icons.star),
  ],
)

// ✅ Column with spaced children
Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Text('Title'),
    SizedBox(height: 16),
    Text('Description'),
  ],
)
```

**Flexible and Expanded:**
- Use `Expanded` to make children fill available space
- Use `Flexible` for children that can shrink but don't necessarily grow
- Set `flex` property to control space distribution

```dart
// ✅ Expanded widgets in a Row
Row(
  children: [
    Expanded(child: TextField()),           // Takes 1/3
    Expanded(flex: 2, child: TextField()),  // Takes 2/3
  ],
)

// ❌ WRONG - Don't mix fixed-width with unconstrained content
Row(
  children: [
    Container(width: 200, child: TextField()),  // Fixed
    TextField(),  // ❌ Unbounded width causes overflow
  ],
)
```

**Stack and Positioned:**
- `Stack` overlays widgets on top of each other
- First child is the base, subsequent children overlay it
- Use `Positioned` to precisely place children
- Use `Align` for alignment-based positioning

```dart
// ✅ Stack with positioned overlay
Stack(
  children: [
    Image.network('url'),  // Base layer
    Positioned(
      top: 10,
      right: 10,
      child: Icon(Icons.favorite),  // Overlay
    ),
  ],
)

// ✅ Stack with alignment
Stack(
  alignment: Alignment.bottomCenter,
  children: [
    Container(height: 200, color: Colors.blue),
    Text('Overlay Text'),
  ],
)
```

**Container:**
- Add padding, margins, borders, and background
- Can constrain size with `width` and `height`
- Accepts a single child
- Use `BoxDecoration` for styling

```dart
// ✅ Styled Container
Container(
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.symmetric(horizontal: 24.width),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
  ),
  child: Text('Content'),
)
```

**ListView and GridView:**
- `ListView` for scrollable vertical/horizontal lists
- Always use `.builder()` constructor for long lists (lazy loading)
- `GridView.count` for fixed column count
- `GridView.extent` for maximum tile width

```dart
// ✅ ListView with builder (efficient)
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(title: Text(items[index])),
)

// ✅ GridView with extent
GridView.extent(
  maxCrossAxisExtent: 150,
  children: items.map((item) => Card(child: Text(item))).toList(),
)

// ❌ WRONG - Don't use ListView() for long lists
ListView(
  children: items.map((item) => ListTile(title: Text(item))).toList(),
)
```

**Wrap:**
- Use when content might overflow a Row or Column
- Automatically moves children to next line
- Good for tags, chips, or flexible layouts

```dart
// ✅ Wrap for dynamic content
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: tags.map((tag) => Chip(label: Text(tag))).toList(),
)
```

#### **Sizing and Constraints**

**Preventing Overflow:**
```dart
// ❌ WRONG - Can cause RenderFlex overflow
Row(
  children: [
    Container(width: 200),
    Container(width: 200),
    Container(width: 200),  // Overflow on small screens
  ],
)

// ✅ CORRECT - Use Expanded
Row(
  children: [
    Expanded(child: Container()),
    Expanded(child: Container()),
    Expanded(child: Container()),
  ],
)

// ✅ CORRECT - Use Flexible with fit
Row(
  children: [
    Flexible(
      fit: FlexFit.tight,
      child: Container(),
    ),
  ],
)
```

**ConstrainedBox and SizedBox:**
```dart
// ✅ Constrain maximum size
ConstrainedBox(
  constraints: BoxConstraints(
    maxWidth: 600,
    maxHeight: 400,
  ),
  child: content,
)

// ✅ Fixed size
SizedBox(
  width: 200,
  height: 100,
  child: content,
)

// ✅ SizedBox for spacing
Column(
  children: [
    Text('First'),
    SizedBox(height: 16),  // Spacing
    Text('Second'),
  ],
)
```

**SingleChildScrollView:**
- Use for content that might exceed screen height
- Wrap content that doesn't have built-in scrolling

```dart
// ✅ Scrollable form
SingleChildScrollView(
  padding: EdgeInsets.all(24.width),
  child: Column(
    children: formFields,
  ),
)
```

#### **Material Layout Widgets**

**Card:**
- Material design card with elevation and rounded corners
- Good for grouping related information
- Accepts a single child (often Column or ListTile)

```dart
// ✅ Card with content
Card(
  elevation: 4,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        ListTile(title: Text('Title')),
        Divider(),
        ListTile(title: Text('Content')),
      ],
    ),
  ),
)
```

**ListTile:**
- Specialized row for up to 3 lines of text
- Supports leading and trailing widgets
- Perfect for lists and menus

```dart
// ✅ ListTile with icons
ListTile(
  leading: Icon(Icons.person),
  title: Text('Name'),
  subtitle: Text('Email'),
  trailing: Icon(Icons.arrow_forward),
  onTap: () {},
)
```

### 11.4. Layout Checklist

When building new UI:
- [ ] Used `CommonPageScaffold` if applicable
- [ ] Avoided hardcoded device checks
- [ ] Used `MediaQuery.sizeOf()` or `LayoutBuilder` for responsive decisions
- [ ] Applied `ConstrainedBox` to prevent content from being too wide
- [ ] Broke down large widgets into smaller components
- [ ] Used `Expanded` or `Flexible` to prevent overflow
- [ ] Applied `ListView.builder` for long lists
- [ ] Wrapped potentially overflowing content in `SingleChildScrollView`
- [ ] Used `Stack` and `Positioned` for overlays
- [ ] Tested on different screen sizes (mobile, tablet, desktop)
- [ ] Verified orientation changes don't break layout
- [ ] Used responsive spacing with `.width` / `.height` extensions

## 12. Dialogs and Confirmation Patterns

### 12.1. Use `showConfirmationDialog` for Simple Confirmations

**Location:** `lib/common/widgets/confirmation_dialog.dart`

For all confirmation dialogs (delete, logout, clear, exit, etc.), use the standardized `showConfirmationDialog` function:

```dart
// ✅ CORRECT - Using standardized confirmation dialog
final confirmed = await showConfirmationDialog(
  context: context,
  title: 'Delete Item',
  message: 'Are you sure you want to delete this item? This action cannot be undone.',
  confirmText: 'Delete',
  cancelText: 'Cancel',
  isDestructive: true,  // Red styling for destructive actions
);

if (confirmed == true) {
  // Perform the action
}
```

**Parameters:**
- `title`: Dialog title (required)
- `message`: Description text (required)
- `confirmText`: Text for confirm button (default: 'Confirmar')
- `cancelText`: Text for cancel button (default: 'Cancelar')
- `isDestructive`: If true, shows warning icon and red confirm button (default: false)

**When to use:**
- ✅ Delete/remove confirmations
- ✅ Logout confirmations
- ✅ Clear data confirmations
- ✅ Exit page confirmations
- ✅ Any yes/no or confirm/cancel action

**When NOT to use:**
- ❌ Form dialogs (use custom `Dialog` widget)
- ❌ Information-only dialogs (use `AlertDialog` or custom)
- ❌ Multi-step dialogs
- ❌ Dialogs with input fields

### 12.2. Pre-built Confirmation Functions

For common scenarios, use pre-built functions:

```dart
// Exit payment page confirmation
await showExitPaymentConfirmation(context);
```

### 12.3. Dialog Styling Guidelines

All dialogs should follow these visual standards:

- **Shape:** `RoundedRectangleBorder` with `borderRadius: 16`
- **Background:** `AppColors.white`
- **Title:** Icon + text in a Row
  - Destructive: Warning icon with `AppColors.salmonPink` background and `AppColors.burntRed` color
  - Informational: Info icon with `AppColors.softBlue` background and `AppColors.teal` color
- **Buttons:** Row with two `Expanded` buttons
  - Cancel: `OutlinedButton` with `AppColors.lightGray` border
  - Confirm: `ElevatedButton` with `AppColors.teal` (or `AppColors.burntRed` for destructive)

### 12.4. Anti-patterns for Dialogs

```dart
// ❌ WRONG - Raw AlertDialog without styling
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Delete'),
    content: const Text('Are you sure?'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
      TextButton(onPressed: () { /* action */ }, child: Text('Delete')),
    ],
  ),
);

// ✅ CORRECT - Using standardized dialog
final confirmed = await showConfirmationDialog(
  context: context,
  title: 'Delete',
  message: 'Are you sure?',
  confirmText: 'Delete',
  isDestructive: true,
);
```

### 12.5. Dialog Checklist

When creating confirmation dialogs:
- [ ] Used `showConfirmationDialog` instead of raw `showDialog`
- [ ] Set `isDestructive: true` for delete/clear/remove actions
- [ ] Provided clear, descriptive `message` text
- [ ] Used appropriate `confirmText` (e.g., 'Delete', 'Exit', 'Clear')
- [ ] Handled the `confirmed == true` case properly
- [ ] Did NOT use raw `AlertDialog` for simple confirmations

## 13. Final notes

Keep the codebase consistent with these rules. If you need a deviation, document the reason and get approval from the maintainers.

---
This English file is a companion translation of the project's Portuguese architecture instructions. The Portuguese version remains the canonical source.
