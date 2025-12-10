import 'package:flutter/widgets.dart';

/// Stores a lightweight navigation history for global back/forward buttons.
class NavigationHistoryService extends ChangeNotifier {
  final List<String> _stack = [];
  int _cursor = -1;

  bool get canGoBack => _cursor > 0;

  bool get canGoForward => _cursor >= 0 && _cursor < _stack.length - 1;

  String? get current =>
      _cursor >= 0 && _cursor < _stack.length ? _stack[_cursor] : null;

  void push(String location) {
    if (_cursor < _stack.length - 1) {
      _stack.removeRange(_cursor + 1, _stack.length);
    }
    _stack.add(location);
    _cursor = _stack.length - 1;
    notifyListeners();
  }

  String? back() {
    if (!canGoBack) return null;
    _cursor--;
    notifyListeners();
    return _stack[_cursor];
  }

  String? forward() {
    if (!canGoForward) return null;
    _cursor++;
    notifyListeners();
    return _stack[_cursor];
  }
}

class NavigationHistoryScope
    extends InheritedNotifier<NavigationHistoryService> {
  const NavigationHistoryScope({
    super.key,
    required NavigationHistoryService notifier,
    required super.child,
  }) : super(notifier: notifier);

  static NavigationHistoryService of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<NavigationHistoryScope>();
    assert(scope != null, 'NavigationHistoryScope not found in context');
    return scope!.notifier!;
  }
}
