---
applyTo: '**'
---
# AI rules for Flutter

You are an expert in Flutter and Dart development. Your goal is to build
beautiful, performant, and maintainable applications following modern best
practices. You have expert experience with application writing, testing, and
running Flutter applications for various platforms, including desktop, web, and
mobile platforms.

## Interaction Guidelines
* **User Persona:** Assume the user is familiar with programming concepts but
  may be new to Dart.
* **Explanations:** When generating code, provide explanations for Dart-specific
  features like null safety, futures, and streams.
* **Clarification:** If a request is ambiguous, ask for clarification on the
  intended functionality and the target platform (e.g., command-line, web,
  server).
* **Dependencies:** When suggesting new dependencies from `pub.dev`, explain
  their benefits.
* **Formatting:** Use the `dart_format` tool to ensure consistent code
  formatting.
* **Fixes:** Use the `dart_fix` tool to automatically fix many common errors,
  and to help code conform to configured analysis options.
* **Linting:** Use the Dart linter with a recommended set of rules to catch
  common issues. Use the `analyze_files` tool to run the linter.

## Project Structure
* **Standard Structure:** Assumes a standard Flutter project structure with
  `lib/main.dart` as the primary application entry point.

## Flutter style guide
* **SOLID Principles:** Apply SOLID principles throughout the codebase.
* **Concise and Declarative:** Write concise, modern, technical Dart code.
  Prefer functional and declarative patterns.
* **Composition over Inheritance:** Favor composition for building complex
  widgets and logic.
* **Immutability:** Prefer immutable data structures. Widgets (especially
  `StatelessWidget`) should be immutable.
* **State Management:** Separate ephemeral state and app state. Use a state
  management solution for app state to handle the separation of concerns.
* **Widgets are for UI:** Everything in Flutter's UI is a widget. Compose
  complex UIs from smaller, reusable widgets.
* **Navigation:** Use a modern routing package like `auto_route` or `go_router`.
  See the [navigation guide](./navigation.md) for a detailed example using
  `go_router`.

## Package Management
* **Pub Tool:** To manage packages, use the `pub` tool, if available.
* **External Packages:** If a new feature requires an external package, use the
  `pub_dev_search` tool, if it is available. Otherwise, identify the most
  suitable and stable package from pub.dev.
* **Adding Dependencies:** To add a regular dependency, use the `pub` tool, if
  it is available. Otherwise, run `flutter pub add <package_name>`.
* **Adding Dev Dependencies:** To add a development dependency, use the `pub`
  tool, if it is available, with `dev:<package name>`. Otherwise, run `flutter
  pub add dev:<package_name>`.
* **Dependency Overrides:** To add a dependency override, use the `pub` tool, if
  it is available, with `override:<package name>:1.0.0`. Otherwise, run `flutter
  pub add override:<package_name>:1.0.0`.
* **Removing Dependencies:** To remove a dependency, use the `pub` tool, if it
  is available. Otherwise, run `dart pub remove <package_name>`.

## Code Quality
* **Code structure:** Adhere to maintainable code structure and separation of
  concerns (e.g., UI logic separate from business logic).
* **Naming conventions:** Avoid abbreviations and use meaningful, consistent,
  descriptive names for variables, functions, and classes.
* **Conciseness:** Write code that is as short as it can be while remaining
  clear.
* **Simplicity:** Write straightforward code. Code that is clever or
  obscure is difficult to maintain.
* **Error Handling:** Anticipate and handle potential errors. Don't let your
  code fail silently.
* **Styling:**
    * Line length: Lines should be 80 characters or fewer.
    * Use `PascalCase` for classes, `camelCase` for
      members/variables/functions/enums, and `snake_case` for files.
* **Functions:**
    * Functions short and with a single purpose (strive for less than 20 lines).
* **Testing:** Write code with testing in mind. Use the `file`, `process`, and
  `platform` packages, if appropriate, so you can inject in-memory and fake
  versions of the objects.
* **Logging:** Use the `logging` package instead of `print`.

## Dart Best Practices
* **Effective Dart:** Follow the official Effective Dart guidelines
  (https://dart.dev/effective-dart)
* **Class Organization:** Define related classes within the same library file.
  For large libraries, export smaller, private libraries from a single top-level
  library.
* **Library Organization:** Group related libraries in the same folder.
* **API Documentation:** Add documentation comments to all public APIs,
  including classes, constructors, methods, and top-level functions.
* **Comments:** Write clear comments for complex or non-obvious code. Avoid
  over-commenting.
* **Trailing Comments:** Don't add trailing comments.
* **Async/Await:** Ensure proper use of `async`/`await` for asynchronous
  operations with robust error handling.
    * Use `Future`s, `async`, and `await` for asynchronous operations.
    * Use `Stream`s for sequences of asynchronous events.
* **Null Safety:** Write code that is soundly null-safe. Leverage Dart's null
  safety features. Avoid `!` unless the value is guaranteed to be non-null.
* **Pattern Matching:** Use pattern matching features where they simplify the
  code.
* **Records:** Use records to return multiple types in situations where defining
  an entire class is cumbersome.
* **Switch Statements:** Prefer using exhaustive `switch` statements or
  expressions, which don't require `break` statements.
* **Exception Handling:** Use `try-catch` blocks for handling exceptions, and
  use exceptions appropriate for the type of exception. Use custom exceptions
  for situations specific to your code.
* **Arrow Functions:** Use arrow syntax for simple one-line functions.

## Flutter Best Practices
* **Immutability:** Widgets (especially `StatelessWidget`) are immutable; when
  the UI needs to change, Flutter rebuilds the widget tree.
* **Composition:** Prefer composing smaller widgets over extending existing
  ones. Use this to avoid deep widget nesting.
* **Private Widgets:** Use small, private `Widget` classes instead of private
  helper methods that return a `Widget`.
* **Build Methods:** Break down large `build()` methods into smaller, reusable
  private Widget classes.
* **List Performance:** Use `ListView.builder` or `SliverList` for long lists to
  create lazy-loaded lists for performance.
* **Isolates:** Use `compute()` to run expensive calculations in a separate
  isolate to avoid blocking the UI thread, such as JSON parsing.
* **Const Constructors:** Use `const` constructors for widgets and in `build()`
  methods whenever possible to reduce rebuilds.
* **Build Method Performance:** Avoid performing expensive operations, like
  network calls or complex computations, directly within `build()` methods.

## API Design Principles
When building reusable APIs, such as a library, follow these principles.

* **Consider the User:** Design APIs from the perspective of the person who will
  be using them. The API should be intuitive and easy to use correctly.
* **Documentation is Essential:** Good documentation is a part of good API
  design. It should be clear, concise, and provide examples.

## Application Architecture
* **Separation of Concerns:** Aim for separation of concerns similar to MVC/MVVM, with defined Model,
  View, and ViewModel/Controller roles.
* **Logical Layers:** Organize the project into logical layers:
    * Presentation (widgets, screens)
    * Domain (business logic classes)
    * Data (model classes, API clients)
    * Core (shared classes, utilities, and extension types)
* **Feature-based Organization:** For larger projects, organize code by feature,
  where each feature has its own presentation, domain, and data subfolders. This
  improves navigability and scalability.

## Lint Rules

Include the package in the `analysis_options.yaml` file. Use the following
analysis_options.yaml file as a starting point:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Add additional lint rules here:
    # avoid_print: false
    # prefer_single_quotes: true
```

### State Management
* **Built-in Solutions:** Prefer Flutter's built-in state management solutions.
  Do not use a third-party package unless explicitly requested.
* **Streams:** Use `Streams` and `StreamBuilder` for handling a sequence of
  asynchronous events.
* **Futures:** Use `Futures` and `FutureBuilder` for handling a single
  asynchronous operation that will complete in the future.
* **ValueNotifier:** Use `ValueNotifier` with `ValueListenableBuilder` for
  simple, local state that involves a single value.

  ```dart
  // Define a ValueNotifier to hold the state.
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  // Use ValueListenableBuilder to listen and rebuild.
  ValueListenableBuilder<int>(
    valueListenable: _counter,
    builder: (context, value, child) {
      return Text('Count: $value');
    },
  );
    ```

* **ChangeNotifier:** For state that is more complex or shared across multiple
  widgets, use `ChangeNotifier`.
* **ListenableBuilder:** Use `ListenableBuilder` to listen to changes from a
  `ChangeNotifier` or other `Listenable`.
* **MVVM:** When a more robust solution is needed, structure the app using the
  Model-View-ViewModel (MVVM) pattern.
* **Dependency Injection:** Use simple manual constructor dependency injection
  to make a class's dependencies explicit in its API, and to manage dependencies
  between different layers of the application.
* **Provider:** If a dependency injection solution beyond manual constructor
  injection is explicitly requested, `provider` can be used to make services,
  repositories, or complex state objects available to the UI layer without tight
  coupling (note: this document generally defaults against third-party packages
  for state management unless explicitly requested).

### Data Flow
* **Data Structures:** Define data structures (classes) to represent the data
  used in the application.
* **Data Abstraction:** Abstract data sources (e.g., API calls, database
  operations) using Repositories/Services to promote testability.

### Routing
* **GoRouter:** Use the `go_router` package for declarative navigation, deep
  linking, and web support.
* **GoRouter Setup:** To use `go_router`, first add it to your `pubspec.yaml`
  using the `pub` tool's `add` command.

  ```dart
  // 1. Add the dependency
  // flutter pub add go_router

  // 2. Configure the router
  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'details/:id', // Route with a path parameter
            builder: (context, state) {
              final String id = state.pathParameters['id']!;
              return DetailScreen(id: id);
            },
          ),
        ],
      ),
    ],
  );

  // 3. Use it in your MaterialApp
  MaterialApp.router(
    routerConfig: _router,
  );
  ```
* **Authentication Redirects:** Configure `go_router`'s `redirect` property to
  handle authentication flows, ensuring users are redirected to the login screen
  when unauthorized, and back to their intended destination after successful
  login.

* **Navigator:** Use the built-in `Navigator` for short-lived screens that do
  not need to be deep-linkable, such as dialogs or temporary views.

  ```dart
  // Push a new screen onto the stack
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const DetailsScreen()),
  );

  // Pop the current screen to go back
  Navigator.pop(context);
  ```

### Data Handling & Serialization
* **JSON Serialization:** Use `json_serializable` and `json_annotation` for
  parsing and encoding JSON data.
* **Field Renaming:** When encoding data, use `fieldRename: FieldRename.snake`
  to convert Dart's camelCase fields to snake_case JSON keys.

  ```dart
  // In your model file
  import 'package:json_annotation/json_annotation.dart';

  part 'user.g.dart';

  @JsonSerializable(fieldRename: FieldRename.snake)
  class User {
    final String firstName;
    final String lastName;

    User({required this.firstName, required this.lastName});

    factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
  }
  ```


### Logging
* **Structured Logging:** Use the `log` function from `dart:developer` for
  structured logging that integrates with Dart DevTools.

  ```dart
  import 'dart:developer' as developer;

  // For simple messages
  developer.log('User logged in successfully.');

  // For structured error logging
  try {
    // ... code that might fail
  } catch (e, s) {
    developer.log(
      'Failed to fetch data',
      name: 'myapp.network',
      level: 1000, // SEVERE
      error: e,
      stackTrace: s,
    );
  }
  ```

## Code Generation
* **Build Runner:** If the project uses code generation, ensure that
  `build_runner` is listed as a dev dependency in `pubspec.yaml`.
* **Code Generation Tasks:** Use `build_runner` for all code generation tasks,
  such as for `json_serializable`.
* **Running Build Runner:** After modifying files that require code generation,
  run the build command:

  ```shell
  dart run build_runner build --delete-conflicting-outputs
  ```

## Testing
* **Running Tests:** To run tests, use the `run_tests` tool if it is available,
  otherwise use `flutter test`.
* **Unit Tests:** Use `package:test` for unit tests.
* **Widget Tests:** Use `package:flutter_test` for widget tests.
* **Integration Tests:** Use `package:integration_test` for integration tests.
* **Assertions:** Prefer using `package:checks` for more expressive and readable
  assertions over the default `matchers`.

### Testing Best practices
* **Convention:** Follow the Arrange-Act-Assert (or Given-When-Then) pattern.
* **Unit Tests:** Write unit tests for domain logic, data layer, and state
  management.
* **Widget Tests:** Write widget tests for UI components.
* **Integration Tests:** For broader application validation, use integration
  tests to verify end-to-end user flows.
* **integration_test package:** Use the `integration_test` package from the
  Flutter SDK for integration tests. Add it as a `dev_dependency` in
  `pubspec.yaml` by specifying `sdk: flutter`.
* **Mocks:** Prefer fakes or stubs over mocks. If mocks are absolutely
  necessary, use `mockito` or `mocktail` to create mocks for dependencies. While
  code generation is common for state management (e.g., with `freezed`), try to
  avoid it for mocks.
* **Coverage:** Aim for high test coverage.

## Flutter Agent Skills Workflows

The guidance below is aligned with practical workflows documented in the
Flutter team's `flutter/skills` repository.

### Skill Installation and Updates
* **Install all Flutter skills:**
  `npx skills add flutter/skills --skill '*' --agent universal`
* **Update installed skills:** Run `npx skills update`.
* **Dart-focused tasks:** Consider also using `dart-lang/skills`.

### Workflow: Declarative Routing and Deep Linking
* **Router Setup:** Use `MaterialApp.router` with a top-level `GoRouter`.
* **Web URL Strategy:** Call `usePathUrlStrategy()` to remove `#` from web URLs
  when deep linking is required.
* **Nested Navigation:** Use `StatefulShellRoute.indexedStack` with
  `StatefulShellBranch` for tab-based UIs that preserve per-tab navigation
  state.
* **Programmatic Navigation:** Prefer `context.go(...)` for declarative route
  replacement and `context.push(...)` for stack-style navigation.
* **Android App Links:** Configure intent filters in
  `android/app/src/main/AndroidManifest.xml` and host
  `/.well-known/assetlinks.json`.
* **iOS Universal Links:** Configure `FlutterDeepLinkingEnabled` in
  `ios/Runner/Info.plist`, associated domains in entitlements, and host
  `/.well-known/apple-app-site-association`.
* **Validation:** Test links with platform tools:
  * Android: `adb shell 'am start -a android.intent.action.VIEW ...'`
  * iOS: `xcrun simctl openurl booted https://yourdomain.com/details/123`

### Workflow: Localization (i18n/l10n)
* **Dependencies:** Add `flutter_localizations` (SDK) and `intl`.
* **Codegen Toggle:** Enable `flutter: generate: true` in `pubspec.yaml`.
* **Configuration:** Create `l10n.yaml` with `arb-dir`,
  `template-arb-file`, and `output-localization-file`.
* **ARB Authoring:** Keep source keys in template ARB and mirror translations
  in locale ARBs.
* **Advanced Messages:** Use ICU message syntax for placeholders, plurals, and
  selects.
* **Generation Loop:** Run `flutter pub get`, inspect ARB/codegen errors,
  then fix and re-run.
* **App Wiring:** Register `AppLocalizations.delegate` and global delegates in
  `MaterialApp`/`CupertinoApp`.

### Workflow: Adaptive and Responsive Layouts
* **Decide by available space, not device type:** Use `LayoutBuilder` with
  `constraints.maxWidth` for breakpoints.
* **Use `MediaQuery.sizeOf(context)`** for app window size, not hardware class.
* **Avoid orientation-only logic:** Do not rely on `OrientationBuilder` or
  `MediaQuery.orientationOf` as a top-level layout switch.
* **Avoid orientation lock:** Support portrait and landscape for better
  large-screen and foldable behavior.
* **Large-Screen Readability:** Wrap broad content in `Center` +
  `ConstrainedBox(maxWidth: ...)`.
* **Collection Scaling:** Prefer `GridView.builder` with
  `SliverGridDelegateWithMaxCrossAxisExtent` on wider screens.

### Workflow: Diagnosing and Fixing Layout Errors
Use this error-to-fix mapping:
* **"Vertical viewport was given unbounded height":** Constrain `ListView`/
  `GridView` inside `Column` with `Expanded` or `SizedBox`.
* **"InputDecorator ... unbounded width":** Wrap `TextField`/
  `TextFormField` in `Expanded` or `Flexible` inside `Row`.
* **"RenderFlex overflowed":** Constrain offending children with `Expanded`/
  `Flexible`, or use wrapping/scrolling where appropriate.
* **"Incorrect use of ParentData widget":** Ensure `Expanded` is a direct
  child of `Row`/`Column`/`Flex`, and `Positioned` is a direct child of `Stack`.
* **"RenderBox was not laid out":** Treat as secondary; fix the primary
  constraint violation earlier in the stack trace.

### Workflow: Networking with http
* **Dependency:** Add `http` package and import as
  `import 'package:http/http.dart' as http;`.
* **Platform Permissions:** Ensure Android Internet permission and macOS network
  entitlements are configured.
* **Request Construction:** Use `Uri.parse(...)`, explicit headers, and
  `jsonEncode(...)` for JSON payloads.
* **Status Validation:** Treat 200/201 as success and throw exceptions for
  failures.
* **No silent nulls:** Do not return `null` on request failure.
* **FutureBuilder Integration:** Handle `snapshot.hasData`, `snapshot.hasError`,
  and loading states consistently.

### Workflow: Manual JSON Serialization
* **Use `dart:convert`:** Decode with `jsonDecode` and encode with
  `jsonEncode`.
* **Type Safety:** Cast decoded dynamic values to
  `Map<String, dynamic>` or `List<dynamic>` explicitly.
* **Model Contract:** Implement `fromJson` and `toJson` in model classes.
* **Payload Size Rule:** Parse small payloads synchronously, but use
  `compute()` for large payloads to avoid UI jank.
* **Isolate Requirement:** Functions passed to `compute()` must be top-level or
  static.

### Workflow: Widget Preview (previews.dart)
* **Import:** Add `package:flutter/widget_previews.dart`.
* **Supported Targets:** Annotate top-level preview functions, static methods,
  or public parameterless constructors/factories.
* **Multi-Config Previews:** Use multiple `@Preview` annotations or
  `MultiPreview` for reusable variants.
* **Limitations:** Preview runs on web runtime; avoid dependencies requiring
  `dart:io` or `dart:ffi`.
* **Asset Paths:** Use package-based asset paths when required by preview
  runtime.
* **CLI Option:** Start previews with `flutter widget-preview start` when IDE
  integration is unavailable.

### Workflow: Widget and Integration Testing
* **Widget Test Loop:**
  * Build with `tester.pumpWidget(...)`.
  * Interact (`tap`, `enterText`, `drag`).
  * Rebuild with `pump()` or `pumpAndSettle()`.
  * Assert initial and post-action states with `expect(...)`.
* **Scrollable Targets:** Use `tester.scrollUntilVisible(...)` before
  interacting with off-screen widgets.
* **Integration Test Setup:**
  * Create tests under `integration_test/`.
  * Initialize with
    `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`.
  * Use stable widget keys (`ValueKey`) for robust targeting.
* **Driver Script:** Keep `test_driver/integration_test.dart` with
  `integrationDriver()` when running with `flutter drive`.
* **Legacy Driver Migration:** If maintaining legacy `flutter_driver` tests,
  prefer progressive migration to `integration_test`.
* **Feedback Loop:** Re-run tests after each fix; if a timeout occurs, inspect
  infinite animations and missing waits.

## Dart Agent Skills Workflows

The guidance below is aligned with practical workflows documented in the
Dart team's `dart-lang/skills` repository.

### Skill Installation and Updates
* **Install all Dart skills:**
  `npx skills add dart-lang/skills --skill '*' --agent universal`
* **Update installed skills:** Run `npx skills update`.
* **Flutter-focused tasks:** Consider also using `flutter/skills`.

### Workflow: Static Analysis and Mechanical Fixes
* **Analyzer Baseline:** Keep `analysis_options.yaml` with an included lint set
  and explicit analyzer/linter configuration.
* **Strict Type Safety:** Prefer enabling `strict-casts`,
  `strict-inference`, and `strict-raw-types`.
* **Run Analysis:** Execute `dart analyze . --fatal-infos` when info-level
  diagnostics should fail validation.
* **Automated Fixes:** Run `dart fix --dry-run`, review, then
  `dart fix --apply`.
* **Reformat After Fixes:** Run `dart format .` after large fix batches.
* **Suppression Hygiene:** Use scoped suppression (`ignore`,
  `ignore_for_file`, analyzer excludes) only for justified false positives.

### Workflow: Type Soundness and Runtime-Safety Triage
* **Generics Discipline:** Explicitly type collections and avoid implicit
  downcasts from `dynamic`.
* **Override Safety:** Respect variance rules in overrides; only use
  `covariant` when narrowing is intentional.
* **Null-Safety Decisions:** Prefer `?.` and `??` when values may be null;
  use `late` only when initialization is guaranteed before read.
* **Error Handling:** Catch `Exception` for recoverable failures and avoid
  catching `Error` subclasses.
* **Feedback Loop:** Re-run `dart analyze` and tests after each fix cycle to
  catch invalid casts and uninitialized `late` reads.

### Workflow: Dependency Auditing and Conflict Resolution
* **Audit Regularly:** Run `dart pub outdated` and evaluate
  Current/Upgradable/Resolvable/Latest columns.
* **Constraint Strategy:** Prefer caret constraints in `pubspec.yaml`.
* **Upgrade Path:** Use `dart pub upgrade` for upgradable versions and
  `dart pub upgrade --tighten` to update lower bounds.
* **Major Bumps:** Update constraints manually to target resolvable major
  versions, then run upgrade.
* **Do Not Nuke Lockfile:** Never delete the whole `pubspec.lock` to solve
  conflicts.
* **Surgical Lockfile Fix:** Remove only the conflicting package block in
  `pubspec.lock`, then run `dart pub get` and verify with `dart pub deps`.
* **CI Reproducibility:** Use `dart pub get --enforce-lockfile` in CI.

### Workflow: Dart Unit Testing
* **File Organization:** Mirror `lib/` structure under `test/` and use
  `_test.dart` suffix.
* **Test API:** Use `group()`, `test()`, `setUp()`, and `tearDown()` to keep
  suites cohesive.
* **Runner Selection:** Use `dart test` for Dart packages,
  `flutter test` for Flutter packages.
* **Integration Location:** For integration tests, run test commands pointing
  to `integration_test/` explicitly.
* **Feedback Loop:** Re-run tests after each failure fix until stable.

### Workflow: Generating and Using Mocks
* **Dependencies:** Add `mockito` and `build_runner` as dev dependencies.
* **Mock Generation:** Prefer `@GenerateNiceMocks` with `MockSpec<T>()`.
* **Async Stubbing Rule:** For async methods, always use
  `thenAnswer((_) async => value)` rather than `thenReturn`.
* **Verification:** Assert interaction contracts using `verify(...).called(n)`.
* **Generation Command:** Run `dart run build_runner build` when updating mock
  specs.

### Workflow: Test Coverage (LCOV)
* **Dependency:** Add `coverage` as a dev dependency.
* **Standard Collection:** Run `dart run coverage:test_with_coverage`.
* **Output Validation:** Ensure `coverage/coverage.json` and
  `coverage/lcov.info` are generated.
* **Selective Exclusion:** Use coverage directives
  (`coverage:ignore-line`, `coverage:ignore-start/end`,
  `coverage:ignore-file`) when justified.
* **Advanced Mode:** For deeper control, use `coverage:collect_coverage` and
  `coverage:format_coverage` with VM service flags.

### Workflow: Building Dart CLI Applications
* **Project Scaffold:** Use `dart create -t cli <project_name>`.
* **Layout:** Keep entry points in `bin/`; implementation in `lib/src/`.
* **Argument Parsing:** Use `ArgParser` for simple CLIs and `CommandRunner` for
  multi-command tools.
* **Exit Codes:** Return explicit non-zero exit codes for failures.
* **Runtime Diagnostics:** Use concise stack traces and avoid swallowing
  exceptions.
* **Distribution:**
  * Development run: `dart run bin/cli.dart`
  * Native binary: `dart compile exe bin/cli.dart -o <output_path>`
  * AOT snapshot: `dart compile aot-snapshot bin/cli.dart`

### Workflow: Migrating Tests to package:checks
* **Dependency Update:** Add `checks` as a dev dependency.
* **Assertion Migration:** Replace matcher-style `expect(...)` assertions with
  `check(...)` assertions.
* **Cascade Assertions:** Use cascades (`..`) for multiple checks on one
  subject.
* **Async Checks:** Use `await check(future).completes(...)` and explicit
  stream checks.
* **Validation Loop:** Re-run analyzer and tests until migration completes with
  zero failures.

### Workflow: Pattern Matching and Switch Expressions
* **Pattern Selection:**
  * Map/List patterns for JSON-like structures.
  * Record patterns for multi-value returns.
  * Object patterns with `sealed` families for exhaustive branching.
* **Switch Choice:** Use switch expressions when producing values and switch
  statements for side effects.
* **Guards:** Apply `when` clauses for conditions not expressible as patterns.
* **Exhaustiveness:** Run analyzer and resolve non-exhaustive switch diagnostics.

## Visual Design & Theming
* **UI Design:** Build beautiful and intuitive user interfaces that follow
  modern design guidelines.
* **Responsiveness:** Ensure the app is mobile responsive and adapts to
  different screen sizes, working perfectly on mobile and web.
* **Navigation:** If there are multiple pages for the user to interact with,
  provide an intuitive and easy navigation bar or controls.
* **Typography:** Stress and emphasize font sizes to ease understanding, e.g.,
  hero text, section headlines, list headlines, keywords in paragraphs.
* **Background:** Apply subtle noise texture to the main background to add a
  premium, tactile feel.
* **Shadows:** Multi-layered drop shadows create a strong sense of depth; cards
  have a soft, deep shadow to look "lifted."
* **Icons:** Incorporate icons to enhance the user’s understanding and the
  logical navigation of the app.
* **Interactive Elements:** Buttons, checkboxes, sliders, lists, charts, graphs,
  and other interactive elements have a shadow with elegant use of color to
  create a "glow" effect.

### Theming
* **Centralized Theme:** Define a centralized `ThemeData` object to ensure a
  consistent application-wide style.
* **Light and Dark Themes:** Implement support for both light and dark themes,
  ideal for a user-facing theme toggle (`ThemeMode.light`, `ThemeMode.dark`,
  `ThemeMode.system`).
* **Color Scheme Generation:** Generate harmonious color palettes from a single
  color using `ColorScheme.fromSeed`.

  ```dart
  final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
    // ... other theme properties
  );
  ```
* **Color Palette:** Include a wide range of color concentrations and hues in
  the palette to create a vibrant and energetic look and feel.
* **Component Themes:** Use specific theme properties (e.g., `appBarTheme`,
  `elevatedButtonTheme`) to customize the appearance of individual Material
  components.
* **Custom Fonts:** For custom fonts, use the `google_fonts` package. Define a
  `TextTheme` to apply fonts consistently.

  ```dart
  // 1. Add the dependency
  // flutter pub add google_fonts

  // 2. Define a TextTheme with a custom font
  final TextTheme appTextTheme = TextTheme(
    displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
    bodyMedium: GoogleFonts.openSans(fontSize: 14),
  );
  ```

### Assets and Images
* **Image Guidelines:** If images are needed, make them relevant and meaningful,
  with appropriate size, layout, and licensing (e.g., freely available). Provide
  placeholder images if real ones are not available.
* **Asset Declaration:** Declare all asset paths in your `pubspec.yaml` file.

    ```yaml
    flutter:
      uses-material-design: true
      assets:
        - assets/images/
    ```

* **Local Images:** Use `Image.asset` for local images from your asset
  bundle.

    ```dart
    Image.asset('assets/images/placeholder.png')
    ```
* **Network images:** Use NetworkImage for images loaded from the network.
* **Cached images:** For cached images, use NetworkImage a package like
  `cached_network_image`.
* **Custom Icons:** Use `ImageIcon` to display an icon from an `ImageProvider`,
  useful for custom icons not in the `Icons` class.
* **Network Images:** Use `Image.network` to display images from a URL, and
  always include `loadingBuilder` and `errorBuilder` for a better user
  experience.

    ```dart
    Image.network(
      'https://picsum.photos/200/300',
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error);
      },
    )
    ```
## UI Theming and Styling Code

* **Responsiveness:** Use `LayoutBuilder` or `MediaQuery` to create responsive
  UIs.
* **Text:** Use `Theme.of(context).textTheme` for text styles.
* **Text Fields:** Configure `textCapitalization`, `keyboardType`, and
* **Responsiveness:** Use `LayoutBuilder` or `MediaQuery` to create responsive
  UIs.
* **Text:** Use `Theme.of(context).textTheme` for text styles.
  remote images.

```dart
// When using network images, always provide an errorBuilder.
Image.network(
  'https://example.com/image.png',
  errorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.error); // Show an error icon
  },
);
```

## Material Theming Best Practices

### Embrace `ThemeData` and Material 3

* **Use `ColorScheme.fromSeed()`:** Use this to generate a complete, harmonious
  color palette for both light and dark modes from a single seed color.
* **Define Light and Dark Themes:** Provide both `theme` and `darkTheme` to your
  `MaterialApp` to support system brightness settings seamlessly.
* **Centralize Component Styles:** Customize specific component themes (e.g.,
  `elevatedButtonTheme`, `cardTheme`, `appBarTheme`) within `ThemeData` to
  ensure consistency.
* **Dark/Light Mode and Theme Toggle:** Implement support for both light and
  dark themes using `theme` and `darkTheme` properties of `MaterialApp`. The
  `themeMode` property can be dynamically controlled (e.g., via a
  `ChangeNotifierProvider`) to allow for toggling between `ThemeMode.light`,
  `ThemeMode.dark`, or `ThemeMode.system`.

```dart
// main.dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 14.0, height: 1.4),
    ),
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
  ),
  home: const MyHomePage(),
);
```

### Implement Design Tokens with `ThemeExtension`

For custom styles that aren't part of the standard `ThemeData`, use
`ThemeExtension` to define reusable design tokens.

* **Create a Custom Theme Extension:** Define a class that extends
  `ThemeExtension<T>` and include your custom properties.
* **Implement `copyWith` and `lerp`:** These methods are required for the
  extension to work correctly with theme transitions.
* **Register in `ThemeData`:** Add your custom extension to the `extensions`
  list in your `ThemeData`.
* **Access Tokens in Widgets:** Use `Theme.of(context).extension<MyColors>()!`
  to access your custom tokens.

```dart
// 1. Define the extension
@immutable
class MyColors extends ThemeExtension<MyColors> {
  const MyColors({required this.success, required this.danger});

  final Color? success;
  final Color? danger;

  @override
  ThemeExtension<MyColors> copyWith({Color? success, Color? danger}) {
    return MyColors(success: success ?? this.success, danger: danger ?? this.danger);
  }

  @override
  ThemeExtension<MyColors> lerp(ThemeExtension<MyColors>? other, double t) {
    if (other is! MyColors) return this;
    return MyColors(
      success: Color.lerp(success, other.success, t),
      danger: Color.lerp(danger, other.danger, t),
    );
  }
}

// 2. Register it in ThemeData
theme: ThemeData(
  extensions: const <ThemeExtension<dynamic>>[
    MyColors(success: Colors.green, danger: Colors.red),
  ],
),

// 3. Use it in a widget
Container(
  color: Theme.of(context).extension<MyColors>()!.success,
)
```

### Styling with `WidgetStateProperty`

* **`WidgetStateProperty.resolveWith`:** Provide a function that receives a
  `Set<WidgetState>` and returns the appropriate value for the current state.
* **`WidgetStateProperty.all`:** A shorthand for when the value is the same for
  all states.

```dart
// Example: Creating a button style that changes color when pressed.
final ButtonStyle myButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return Colors.green; // Color when pressed
      }
      return Colors.red; // Default color
    },
  ),
);
```

## Layout Best Practices

### Building Flexible and Overflow-Safe Layouts

#### For Rows and Columns

* **`Expanded`:** Use to make a child widget fill the remaining available space
  along the main axis.
* **`Flexible`:** Use when you want a widget to shrink to fit, but not
  necessarily grow. Don't combine `Flexible` and `Expanded` in the same `Row` or
  `Column`.
* **`Wrap`:** Use when you have a series of widgets that would overflow a `Row`
  or `Column`, and you want them to move to the next line.

#### For General Content

* **`SingleChildScrollView`:** Use when your content is intrinsically larger
  than the viewport, but is a fixed size.
* **`ListView` / `GridView`:** For long lists or grids of content, always use a
  builder constructor (`.builder`).
* **`FittedBox`:** Use to scale or fit a single child widget within its parent.
* **`LayoutBuilder`:** Use for complex, responsive layouts to make decisions
  based on the available space.

### Layering Widgets with Stack

* **`Positioned`:** Use to precisely place a child within a `Stack` by anchoring it to the edges.
* **`Align`:** Use to position a child within a `Stack` using alignments like `Alignment.center`.

### Advanced Layout with Overlays

* **`OverlayPortal`:** Use this widget to show UI elements (like custom
  dropdowns or tooltips) "on top" of everything else. It manages the
  `OverlayEntry` for you.

  ```dart
  class MyDropdown extends StatefulWidget {
    const MyDropdown({super.key});

    @override
    State<MyDropdown> createState() => _MyDropdownState();
  }

  class _MyDropdownState extends State<MyDropdown> {
    final _controller = OverlayPortalController();

    @override
    Widget build(BuildContext context) {
      return OverlayPortal(
        controller: _controller,
        overlayChildBuilder: (BuildContext context) {
          return const Positioned(
            top: 50,
            left: 10,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('I am an overlay!'),
              ),
            ),
          );
        },
        child: ElevatedButton(
          onPressed: _controller.toggle,
          child: const Text('Toggle Overlay'),
        ),
      );
    }
  }
  ```

## Color Scheme Best Practices

### Contrast Ratios

* **WCAG Guidelines:** Aim to meet the Web Content Accessibility Guidelines
  (WCAG) 2.1 standards.
* **Minimum Contrast:**
    * **Normal Text:** A contrast ratio of at least **4.5:1**.
    * **Large Text:** (18pt or 14pt bold) A contrast ratio of at least **3:1**.

### Palette Selection

* **Primary, Secondary, and Accent:** Define a clear color hierarchy.
* **The 60-30-10 Rule:** A classic design rule for creating a balanced color scheme.
    * **60%** Primary/Neutral Color (Dominant)
    * **30%** Secondary Color
    * **10%** Accent Color

### Complementary Colors

* **Use with Caution:** They can be visually jarring if overused.
* **Best Use Cases:** They are excellent for accent colors to make specific
  elements pop, but generally poor for text and background pairings as they can
  cause eye strain.

### Example Palette

* **Primary:** #0D47A1 (Dark Blue)
* **Secondary:** #1976D2 (Medium Blue)
* **Accent:** #FFC107 (Amber)
* **Neutral/Text:** #212121 (Almost Black)
* **Background:** #FEFEFE (Almost White)

## Font Best Practices

### Font Selection

* **Limit Font Families:** Stick to one or two font families for the entire
  application.
* **Prioritize Legibility:** Choose fonts that are easy to read on screens of
  all sizes. Sans-serif fonts are generally preferred for UI body text.
* **System Fonts:** Consider using platform-native system fonts.
* **Google Fonts:** For a wide selection of open-source fonts, use the
  `google_fonts` package.

### Hierarchy and Scale

* **Establish a Scale:** Define a set of font sizes for different text elements
  (e.g., headlines, titles, body text, captions).
* **Use Font Weight:** Differentiate text effectively using font weights.
* **Color and Opacity:** Use color and opacity to de-emphasize less important
  text.

### Readability

* **Line Height (Leading):** Set an appropriate line height, typically **1.4x to
  1.6x** the font size.
* **Line Length:** For body text, aim for a line length of **45-75 characters**.
* **Avoid All Caps:** Do not use all caps for long-form text.

### Example Typographic Scale

```dart
// In your ThemeData
textTheme: const TextTheme(
  displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
  titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
  bodyLarge: TextStyle(fontSize: 16.0, height: 1.5),
  bodyMedium: TextStyle(fontSize: 14.0, height: 1.4),
  labelSmall: TextStyle(fontSize: 11.0, color: Colors.grey),
),
```

## Documentation

* **`dartdoc`:** Write `dartdoc`-style comments for all public APIs.


### Documentation Philosophy

* **Comment wisely:** Use comments to explain why the code is written a certain
  way, not what the code does. The code itself should be self-explanatory.
* **Document for the user:** Write documentation with the reader in mind. If you
  had a question and found the answer, add it to the documentation where you
  first looked. This ensures the documentation answers real-world questions.
* **No useless documentation:** If the documentation only restates the obvious
  from the code's name, it's not helpful. Good documentation provides context
  and explains what isn't immediately apparent.
* **Consistency is key:** Use consistent terminology throughout your
  documentation.

### Commenting Style

* **Use `///` for doc comments:** This allows documentation generation tools to
  pick them up.
* **Start with a single-sentence summary:** The first sentence should be a
  concise, user-centric summary ending with a period.
* **Separate the summary:** Add a blank line after the first sentence to create
  a separate paragraph. This helps tools create better summaries.
* **Avoid redundancy:** Don't repeat information that's obvious from the code's
  context, like the class name or signature.
* **Don't document both getter and setter:** For properties with both, only
  document one. The documentation tool will treat them as a single field.

### Writing Style

* **Be brief:** Write concisely.
* **Avoid jargon and acronyms:** Don't use abbreviations unless they are widely
  understood.
* **Use Markdown sparingly:** Avoid excessive markdown and never use HTML for
  formatting.
* **Use backticks for code:** Enclose code blocks in backtick fences, and
  specify the language.

### What to Document

* **Public APIs are a priority:** Always document public APIs.
* **Consider private APIs:** It's a good idea to document private APIs as well.
* **Library-level comments are helpful:** Consider adding a doc comment at the
  library level to provide a general overview.
* **Include code samples:** Where appropriate, add code samples to illustrate usage.
* **Explain parameters, return values, and exceptions:** Use prose to describe
  what a function expects, what it returns, and what errors it might throw.
* **Place doc comments before annotations:** Documentation should come before
  any metadata annotations.

## Accessibility (A11Y)
Implement accessibility features to empower all users, assuming a wide variety
of users with different physical abilities, mental abilities, age groups,
education levels, and learning styles.

* **Color Contrast:** Ensure text has a contrast ratio of at least **4.5:1**
  against its background.
* **Dynamic Text Scaling:** Test your UI to ensure it remains usable when users
  increase the system font size.
* **Semantic Labels:** Use the `Semantics` widget to provide clear, descriptive
  labels for UI elements.
* **Screen Reader Testing:** Regularly test your app with TalkBack (Android) and
  VoiceOver (iOS).