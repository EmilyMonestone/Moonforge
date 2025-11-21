# Step 5: Standardize Async State Management

**Priority**: High  
**Effort**: L (6-10 days)  
**Branch**: `refactor/05-async-state`

## Goal

Normalize how asynchronous operations and their states (loading, success, error) are handled across all features. This eliminates inconsistent patterns, makes the codebase more predictable, and simplifies error handling.

By the end of this step:
- All async operations use a consistent state pattern
- Loading, error, and success states are handled uniformly
- Error messages are user-friendly and consistent
- Code is more testable with clear state boundaries

## Scope

**What's included:**
- Provider/Controller classes that handle async operations
- API calls and data fetching
- Form submissions and mutations
- Error handling patterns

**What's excluded:**
- UI widgets (covered in other steps)
- Synchronous state management
- Simple boolean flags (unless they represent async state)

**Types of changes allowed:**
- Creating async state wrapper classes
- Refactoring providers to use async state
- Standardizing error handling
- Adding loading indicators

## Instructions

### 1. Create AsyncState Wrapper

Define a generic class to represent async operation states:

**lib/core/models/async_state.dart:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'async_state.freezed.dart';

/// Represents the state of an asynchronous operation.
///
/// Use this to wrap any data that comes from async operations (API calls,
/// database queries, etc.) to properly handle loading, error, and success states.
@freezed
class AsyncState<T> with _$AsyncState<T> {
  /// Initial state before any operation
  const factory AsyncState.idle() = _AsyncStateIdle<T>;

  /// Loading state while operation is in progress
  const factory AsyncState.loading() = _AsyncStateLoading<T>;

  /// Success state with data
  const factory AsyncState.data(T data) = _AsyncStateData<T>;

  /// Error state with error details
  const factory AsyncState.error(Object error, [StackTrace? stackTrace]) =
      _AsyncStateError<T>;

  const AsyncState._();

  /// Whether the state is idle
  bool get isIdle => this is _AsyncStateIdle<T>;

  /// Whether the state is loading
  bool get isLoading => this is _AsyncStateLoading<T>;

  /// Whether the state has data
  bool get hasData => this is _AsyncStateData<T>;

  /// Whether the state has error
  bool get hasError => this is _AsyncStateError<T>;

  /// Get the data if available, otherwise null
  T? get dataOrNull => maybeMap(
        data: (state) => state.data,
        orElse: () => null,
      );

  /// Get the error if available, otherwise null
  Object? get errorOrNull => maybeMap(
        error: (state) => state.error,
        orElse: () => null,
      );
}
```

Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Create Base Provider Pattern

Create a base class for providers that handle async operations:

**lib/core/providers/base_async_provider.dart:**
```dart
import 'package:flutter/foundation.dart';
import 'package:moonforge/core/models/async_state.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Base class for providers that handle asynchronous operations.
///
/// Provides common functionality for loading states, error handling,
/// and notifying listeners.
abstract class BaseAsyncProvider<T> extends ChangeNotifier {
  AsyncState<T> _state = const AsyncState.idle();

  /// Current async state
  AsyncState<T> get state => _state;

  /// Update state and notify listeners
  @protected
  void updateState(AsyncState<T> newState) {
    _state = newState;
    notifyListeners();
  }

  /// Execute an async operation with automatic state management
  @protected
  Future<void> executeAsync(Future<T> Function() operation) async {
    updateState(const AsyncState.loading());
    try {
      final result = await operation();
      updateState(AsyncState.data(result));
    } catch (error, stackTrace) {
      logger.e('Async operation failed', error: error, stackTrace: stackTrace);
      updateState(AsyncState.error(error, stackTrace));
    }
  }

  /// Reset state to idle
  void reset() {
    updateState(const AsyncState.idle());
  }
}
```

### 3. Refactor Existing Providers

Transform existing providers to use the new async state pattern.

#### Before (ad-hoc state management):

```dart
class CampaignProvider extends ChangeNotifier {
  List<Campaign>? _campaigns;
  bool _isLoading = false;
  String? _error;

  List<Campaign>? get campaigns => _campaigns;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCampaigns() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _campaigns = await _campaignService.fetchCampaigns();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _campaigns = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

#### After (using AsyncState):

```dart
class CampaignProvider extends BaseAsyncProvider<List<Campaign>> {
  final CampaignService _campaignService;

  CampaignProvider(this._campaignService);

  /// Get campaigns, or empty list if not loaded
  List<Campaign> get campaigns => state.dataOrNull ?? [];

  /// Load campaigns from service
  Future<void> loadCampaigns() async {
    await executeAsync(() => _campaignService.fetchCampaigns());
  }

  /// Refresh campaigns
  Future<void> refresh() => loadCampaigns();
}
```

### 4. Handle Multiple Async Operations

For providers with multiple independent async operations:

```dart
class CampaignDetailsProvider extends ChangeNotifier {
  final CampaignService _campaignService;
  final ChapterService _chapterService;

  AsyncState<Campaign> _campaignState = const AsyncState.idle();
  AsyncState<List<Chapter>> _chaptersState = const AsyncState.idle();

  AsyncState<Campaign> get campaignState => _campaignState;
  AsyncState<List<Chapter>> get chaptersState => _chaptersState;

  Campaign? get campaign => _campaignState.dataOrNull;
  List<Chapter> get chapters => _chaptersState.dataOrNull ?? [];

  CampaignDetailsProvider(this._campaignService, this._chapterService);

  Future<void> loadCampaign(String campaignId) async {
    _campaignState = const AsyncState.loading();
    notifyListeners();

    try {
      final campaign = await _campaignService.fetchCampaign(campaignId);
      _campaignState = AsyncState.data(campaign);
    } catch (error, stackTrace) {
      _campaignState = AsyncState.error(error, stackTrace);
    }
    notifyListeners();
  }

  Future<void> loadChapters(String campaignId) async {
    _chaptersState = const AsyncState.loading();
    notifyListeners();

    try {
      final chapters = await _chapterService.fetchChapters(campaignId);
      _chaptersState = AsyncState.data(chapters);
    } catch (error, stackTrace) {
      _chaptersState = AsyncState.error(error, stackTrace);
    }
    notifyListeners();
  }

  Future<void> load(String campaignId) async {
    await Future.wait([
      loadCampaign(campaignId),
      loadChapters(campaignId),
    ]);
  }
}
```

### 5. Create AsyncStateBuilder Widget

Create a widget to easily consume async state in UI:

**lib/core/widgets/async_state_builder.dart:**
```dart
import 'package:flutter/material.dart';
import 'package:moonforge/core/models/async_state.dart';
import 'package:moonforge/core/widgets/error_display.dart';
import 'package:moonforge/core/widgets/loading_indicator.dart';

/// A widget that builds different UI based on async state.
///
/// Handles loading, error, and success states automatically.
class AsyncStateBuilder<T> extends StatelessWidget {
  final AsyncState<T> state;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context)? onLoading;
  final Widget Function(BuildContext context, Object error)? onError;
  final Widget Function(BuildContext context)? onIdle;

  const AsyncStateBuilder({
    super.key,
    required this.state,
    required this.builder,
    this.onLoading,
    this.onError,
    this.onIdle,
  });

  @override
  Widget build(BuildContext context) {
    return state.when(
      idle: () => onIdle?.call(context) ?? const SizedBox.shrink(),
      loading: () => onLoading?.call(context) ?? const LoadingIndicator(),
      data: (data) => builder(context, data),
      error: (error, _) =>
          onError?.call(context, error) ??
          ErrorDisplay(
            message: error.toString(),
          ),
    );
  }
}
```

**Usage in views:**

```dart
class CampaignListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CampaignProvider>(context);

    return AsyncStateBuilder<List<Campaign>>(
      state: provider.state,
      builder: (context, campaigns) {
        if (campaigns.isEmpty) {
          return EmptyState(
            icon: Icons.campaign,
            title: 'No campaigns',
            message: 'Create your first campaign',
            actionLabel: 'Create Campaign',
            onAction: () => _showCreateDialog(context),
          );
        }

        return ListView.builder(
          itemCount: campaigns.length,
          itemBuilder: (context, index) => CampaignCard(
            campaign: campaigns[index],
          ),
        );
      },
      onError: (context, error) => ErrorDisplay(
        title: 'Failed to load campaigns',
        message: error.toString(),
        onRetry: () => provider.loadCampaigns(),
      ),
    );
  }
}
```

### 6. Standardize Error Handling

Create user-friendly error messages:

**lib/core/utils/error_handler.dart:**
```dart
/// Converts technical errors into user-friendly messages
class ErrorHandler {
  /// Get a user-friendly error message
  static String getUserMessage(Object error) {
    if (error is NetworkError) {
      return 'No internet connection. Please check your network.';
    } else if (error is AuthenticationError) {
      return 'You need to sign in to continue.';
    } else if (error is ValidationError) {
      return error.message;
    } else if (error is ServerError) {
      return 'Server error. Please try again later.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  /// Log the error for debugging
  static void logError(Object error, StackTrace? stackTrace) {
    logger.e('Error occurred', error: error, stackTrace: stackTrace);
  }
}

// Custom error types
class NetworkError implements Exception {
  final String message;
  NetworkError([this.message = 'Network error']);
}

class AuthenticationError implements Exception {
  final String message;
  AuthenticationError([this.message = 'Authentication failed']);
}

class ValidationError implements Exception {
  final String message;
  ValidationError(this.message);
}

class ServerError implements Exception {
  final int? statusCode;
  final String message;
  ServerError([this.statusCode, this.message = 'Server error']);
}
```

Update AsyncStateBuilder to use ErrorHandler:

```dart
error: (error, _) =>
    onError?.call(context, error) ??
    ErrorDisplay(
      message: ErrorHandler.getUserMessage(error),
    ),
```

### 7. Handle Form Submission States

For forms and mutations:

```dart
class CampaignFormProvider extends ChangeNotifier {
  final CampaignService _campaignService;

  AsyncState<void> _submitState = const AsyncState.idle();

  AsyncState<void> get submitState => _submitState;
  bool get isSubmitting => _submitState.isLoading;
  bool get submitSuccess => _submitState.hasData;
  Object? get submitError => _submitState.errorOrNull;

  CampaignFormProvider(this._campaignService);

  Future<void> createCampaign(Campaign campaign) async {
    _submitState = const AsyncState.loading();
    notifyListeners();

    try {
      await _campaignService.createCampaign(campaign);
      _submitState = const AsyncState.data(null);
    } catch (error, stackTrace) {
      _submitState = AsyncState.error(error, stackTrace);
    }
    notifyListeners();
  }

  void resetSubmit() {
    _submitState = const AsyncState.idle();
    notifyListeners();
  }
}
```

**Usage in form:**

```dart
ElevatedButton(
  onPressed: provider.isSubmitting ? null : () async {
    await provider.createCampaign(campaign);
    if (provider.submitSuccess) {
      Navigator.of(context).pop();
    } else if (provider.submitError != null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ErrorHandler.getUserMessage(provider.submitError!)),
        ),
      );
    }
  },
  child: provider.isSubmitting
      ? const InlineLoadingIndicator()
      : const Text('Create'),
);
```

### 8. Add Retry Mechanisms

Implement retry logic for failed operations:

```dart
/// Extension to add retry capability to async operations
extension AsyncRetry on BaseAsyncProvider {
  /// Retry the last failed operation
  Future<void> retry(Future<void> Function() operation) async {
    if (!state.hasError) return;
    await operation();
  }
}
```

### 9. Update All Features

Systematically update each feature:

1. **Campaign feature**: Update CampaignProvider, CampaignDetailsProvider
2. **Encounter feature**: Update EncounterProvider, InitiativeTrackerController
3. **Entity feature**: Update EntityProvider
4. **Session feature**: Update SessionProvider
5. Continue for all features...

## Safety & Verification

### Potential Pitfalls

1. **Lost loading states**: Ensure all loading indicators are properly shown
2. **Error state leaks**: Reset error states when retrying operations
3. **Memory leaks**: Dispose providers properly
4. **Null safety**: Handle cases where data might not be loaded

### Verification Checklist

- [ ] All providers use AsyncState
- [ ] Loading states are visible in UI
- [ ] Error messages are user-friendly
- [ ] Retry functionality works
- [ ] Tests updated for new state patterns
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes

### Testing Strategy

**Unit tests for providers:**

```dart
test('CampaignProvider loads campaigns successfully', () async {
  final service = MockCampaignService();
  final provider = CampaignProvider(service);

  when(service.fetchCampaigns()).thenAnswer(
    (_) async => [Campaign(id: '1', name: 'Test')],
  );

  expect(provider.state.isIdle, true);

  await provider.loadCampaigns();

  expect(provider.state.hasData, true);
  expect(provider.campaigns, hasLength(1));
});

test('CampaignProvider handles errors', () async {
  final service = MockCampaignService();
  final provider = CampaignProvider(service);

  when(service.fetchCampaigns()).thenThrow(NetworkError());

  await provider.loadCampaigns();

  expect(provider.state.hasError, true);
  expect(provider.state.errorOrNull, isA<NetworkError>());
});
```

**Widget tests:**

```dart
testWidgets('Shows loading indicator while loading', (tester) async {
  final provider = CampaignProvider(MockCampaignService());
  provider.updateState(const AsyncState.loading());

  await tester.pumpWidget(
    MaterialApp(
      home: ChangeNotifierProvider.value(
        value: provider,
        child: CampaignListView(),
      ),
    ),
  );

  expect(find.byType(LoadingIndicator), findsOneWidget);
});
```

## Git Workflow Tip

**Branch naming**: `refactor/05-async-state`

**Commit strategy**:
```bash
git commit -m "refactor: create AsyncState wrapper class"
git commit -m "refactor: create BaseAsyncProvider"
git commit -m "refactor: add AsyncStateBuilder widget"
git commit -m "refactor: update campaign providers to use AsyncState"
git commit -m "refactor: update encounter providers to use AsyncState"
git commit -m "refactor: standardize error handling"
```

## Impact Assessment

**Risk level**: Medium  
**Files affected**: 30-50 providers and views  
**Breaking changes**: None (internal refactor)  
**Migration needed**: Update all providers incrementally

## Next Step

Once this step is complete and merged, proceed to [Step 6: Repository Pattern Consistency](step-6.md).
