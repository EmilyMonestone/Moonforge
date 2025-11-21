import 'package:flutter/material.dart';

/// Represents the current sync state of the offline-first system
enum SyncState {
  /// All data is synchronized
  synced,

  /// Currently synchronizing data
  syncing,

  /// There are pending changes to sync
  pendingSync,

  /// Sync error occurred
  error,

  /// Offline mode (no connection)
  offline,
}

/// Widget that displays the current sync state with an icon and tooltip
class SyncStateWidget extends StatelessWidget {
  final SyncState state;
  final int? pendingCount;
  final String? errorMessage;
  final VoidCallback? onTap;

  const SyncStateWidget({
    super.key,
    required this.state,
    this.pendingCount,
    this.errorMessage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Tooltip(
      message: _getTooltipMessage(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(_getIcon(), color: _getColor(colorScheme), size: 20),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (state) {
      case SyncState.synced:
        return Icons.cloud_done;
      case SyncState.syncing:
        return Icons.cloud_sync;
      case SyncState.pendingSync:
        return Icons.cloud_upload;
      case SyncState.error:
        return Icons.cloud_off;
      case SyncState.offline:
        return Icons.cloud_off;
    }
  }

  Color _getColor(ColorScheme colorScheme) {
    switch (state) {
      case SyncState.synced:
        return colorScheme.primary;
      case SyncState.syncing:
        return colorScheme.secondary;
      case SyncState.pendingSync:
        return colorScheme.tertiary;
      case SyncState.error:
        return colorScheme.error;
      case SyncState.offline:
        return colorScheme.onSurfaceVariant;
    }
  }

  String _getTooltipMessage() {
    switch (state) {
      case SyncState.synced:
        return 'All changes synced';
      case SyncState.syncing:
        return 'Syncing changes...';
      case SyncState.pendingSync:
        final count = pendingCount ?? 0;
        return count > 0
            ? 'Pending: $count ${count == 1 ? 'change' : 'changes'}'
            : 'Pending sync';
      case SyncState.error:
        return errorMessage ?? 'Sync error occurred';
      case SyncState.offline:
        return 'Offline - changes will sync when online';
    }
  }
}

/// Animated sync state widget with pulsing animation for syncing state
class AnimatedSyncStateWidget extends StatefulWidget {
  final SyncState state;
  final int? pendingCount;
  final String? errorMessage;
  final VoidCallback? onTap;

  const AnimatedSyncStateWidget({
    super.key,
    required this.state,
    this.pendingCount,
    this.errorMessage,
    this.onTap,
  });

  @override
  State<AnimatedSyncStateWidget> createState() =>
      _AnimatedSyncStateWidgetState();
}

class _AnimatedSyncStateWidgetState extends State<AnimatedSyncStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _updateAnimation();
  }

  @override
  void didUpdateWidget(AnimatedSyncStateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    if (widget.state == SyncState.syncing) {
      _controller.repeat();
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Tooltip(
      message: _getTooltipMessage(),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.state == SyncState.syncing
              ? RotationTransition(
                  turns: _controller,
                  child: Icon(
                    Icons.cloud_sync,
                    color: _getColor(colorScheme),
                    size: 20,
                  ),
                )
              : Icon(_getIcon(), color: _getColor(colorScheme), size: 20),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (widget.state) {
      case SyncState.synced:
        return Icons.cloud_done;
      case SyncState.syncing:
        return Icons.cloud_sync;
      case SyncState.pendingSync:
        return Icons.cloud_upload;
      case SyncState.error:
        return Icons.cloud_off;
      case SyncState.offline:
        return Icons.cloud_off;
    }
  }

  Color _getColor(ColorScheme colorScheme) {
    switch (widget.state) {
      case SyncState.synced:
        return colorScheme.primary;
      case SyncState.syncing:
        return colorScheme.secondary;
      case SyncState.pendingSync:
        return colorScheme.tertiary;
      case SyncState.error:
        return colorScheme.error;
      case SyncState.offline:
        return colorScheme.onSurfaceVariant;
    }
  }

  String _getTooltipMessage() {
    switch (widget.state) {
      case SyncState.synced:
        return 'All changes synced';
      case SyncState.syncing:
        return 'Syncing changes...';
      case SyncState.pendingSync:
        final count = widget.pendingCount ?? 0;
        return count > 0
            ? 'Pending: $count ${count == 1 ? 'change' : 'changes'}'
            : 'Pending sync';
      case SyncState.error:
        return widget.errorMessage ?? 'Sync error occurred';
      case SyncState.offline:
        return 'Offline - changes will sync when online';
    }
  }
}
