# SimohuApp Copilot Instructions

## Core Architecture
- **Clean Architecture**: Strictly follow `data`, `domain`, and `presentation` layers.
- **Data Flow**: `DataSource` -> `Repository` -> `UseCase` -> `State/Notifier`.
- **Naming Conventions**:
  - `*DataModel`: Classes in the data layer (matches API/JSON).
  - `*Entity`: Classes in the domain/presentation layer.
  - `*UseCase`: Business logic that converts DataModels to Entities.
  - `*Notifier`: Riverpod state management (prefers `AsyncNotifier` or `Notifier`).

## State Management (Riverpod)
- Use `autoDispose` for all providers mapping to specific screens or ephemeral data.
- Favor `AsyncNotifier` for operations involving network calls.
- **Pagination Pattern**: Use a `Notifier` that maintains a private list (e.g., `_allHistory`) to append data on subsequent pages. Reset the list when the filter's `page` returns to 1.
- **Filters**: Manage search and filter state in a separate `Notifier` (e.g., `ExtractFilters`). Reset `page` to 1 whenever a filter (other than page) changes.

## Network & Offline
- All API calls must use `ApiService.request`.
- **Query Parameters**: Pass filters as `queryParameters` in `ApiService.request`.
- **Offline Queuing**: Mutative requests (POST/PUT/PATCH/DELETE) are automatically enqueued if the user is offline. GET requests should typically fail or be handled by cache.

## UI & Widgets
- Use `exports.dart` in `lib/` and sub-folders to manage common imports.
- Prefer small, reusable stateless widgets.
- Use `Theme.of(context)` for styling to ensure consistency with the app theme.
- For lists, use `ListView.builder` or `SliverList` for performance.
- Use `GroupedTransactions` pattern for history lists that need date headers.

## Development Workflows
- **Formatting**: Always use `dart_format`.
- **Linting**: Follow the rules in `analysis_options.yaml`.
- **Build Runner**: If code generation is added (e.g., `json_serializable`), use `dart run build_runner build`.

## Specific Implementation Notes
- **Extract/History**: Server-side filtering accepts `term`, `dtStart`, `dtEnd`, `page`, and `perPage`.
- **Date Formatting**: API dates are typically `YYYY-MM-DD`. UI dates are usually `DD/MM/YYYY`. Use `intl` for conversions.
- **Currency**: Format values using `R$ 0,00` (Brazilian Real) in the presentation layer.
