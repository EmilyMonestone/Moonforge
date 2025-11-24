import 'package:flutter/material.dart';
import 'package:moonforge/core/design/design_system.dart';

/// Primary action button with consistent padding/theme surface.
///
/// ```dart
/// ActionButton(
///   label: l10n.createCampaign,
///   icon: Icons.add,
///   onPressed: onCreateCampaign,
///   isExpanded: true,
/// );
/// ```
class ActionButton extends StatefulWidget {
  const ActionButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.asyncOnPressed,
    this.isExpanded = false,
    this.isBusy = false,
    this.busyLabel,
  }) : assert(
         onPressed == null || asyncOnPressed == null,
         'Use either onPressed or asyncOnPressed',
       );

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Future<void> Function()? asyncOnPressed;
  final bool isExpanded;
  final bool isBusy;
  final String? busyLabel;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _internalBusy = false;

  bool get isBusy => widget.isBusy || _internalBusy;

  String get _currentLabel =>
      isBusy && widget.busyLabel != null ? widget.busyLabel! : widget.label;

  @override
  Widget build(BuildContext context) {
    final child = widget.icon == null
        ? Text(_currentLabel)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon),
              const SizedBox(width: 8),
              Text(_currentLabel),
            ],
          );

    final button = ElevatedButton(
      onPressed: isBusy ? null : _handlePressed,
      style: _style(context),
      child: isBusy
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(_currentLabel),
              ],
            )
          : child,
    );

    return widget.isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Future<void> _handlePressed() async {
    if (widget.asyncOnPressed != null) {
      setState(() => _internalBusy = true);
      try {
        await widget.asyncOnPressed!();
      } finally {
        if (mounted) {
          setState(() => _internalBusy = false);
        }
      }
    } else {
      widget.onPressed?.call();
    }
  }

  ButtonStyle _style(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ElevatedButton.styleFrom(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      textStyle: Theme.of(context).textTheme.titleMedium,
    );
  }
}
