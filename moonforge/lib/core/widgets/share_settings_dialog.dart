import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/utils/share_token_utils.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:toastification/toastification.dart';

/// Dialog for managing session share settings.
class ShareSettingsDialog extends StatefulWidget {
  const ShareSettingsDialog({
    super.key,
    required this.session,
    required this.onUpdate,
  });

  final Session session;
  final Future<void> Function(Session) onUpdate;

  @override
  State<ShareSettingsDialog> createState() => _ShareSettingsDialogState();
}

class _ShareSettingsDialogState extends State<ShareSettingsDialog> {
  bool _isLoading = false;
  late bool _shareEnabled;
  String? _shareToken;
  DateTime? _shareExpiresAt;

  @override
  void initState() {
    super.initState();
    _shareEnabled = widget.session.shareEnabled;
    _shareToken = widget.session.shareToken;
    _shareExpiresAt = widget.session.shareExpiresAt;
  }

  String _getShareUrl() {
    if (_shareToken == null) return '';
    final origin = Uri.base.origin;
    return '$origin/share/session/$_shareToken';
  }

  Future<void> _enableSharing() async {
    setState(() => _isLoading = true);
    try {
      final token = ShareTokenUtils.generateToken();
      final updatedSession = widget.session.copyWith(
        shareEnabled: true,
        shareToken: token,
        updatedAt: DateTime.now(),
        rev: widget.session.rev + 1,
      );
      await widget.onUpdate(updatedSession);
      setState(() {
        _shareEnabled = true;
        _shareToken = token;
      });
      if (mounted) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text('Sharing enabled'),
        );
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to enable sharing'),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _disableSharing() async {
    setState(() => _isLoading = true);
    try {
      final updatedSession = widget.session.copyWith(
        shareEnabled: false,
        shareToken: null,
        shareExpiresAt: null,
        updatedAt: DateTime.now(),
        rev: widget.session.rev + 1,
      );
      await widget.onUpdate(updatedSession);
      setState(() {
        _shareEnabled = false;
        _shareToken = null;
        _shareExpiresAt = null;
      });
      if (mounted) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text('Sharing disabled'),
        );
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to disable sharing'),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _copyLink() async {
    final url = _getShareUrl();
    await Clipboard.setData(ClipboardData(text: url));
    if (mounted) {
      toastification.show(
        type: ToastificationType.success,
        title: const Text('Link copied to clipboard'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.shareSettings),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Share this session\'s log with players via a public link',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _shareEnabled ? Icons.link : Icons.link_off,
                          color: _shareEnabled
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _shareEnabled
                              ? 'Sharing Enabled'
                              : 'Sharing Disabled',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    if (_shareEnabled && _shareToken != null) ...[
                      const SizedBox(height: 16),
                      Text('Share Link', style: theme.textTheme.labelMedium),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                _getShareUrl(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _isLoading ? null : _copyLink,
                              icon: const Icon(Icons.copy, size: 20),
                              tooltip: 'Copy link',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '⚠️ Anyone with this link can view the session log',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
        if (_shareEnabled)
          ButtonM3E(
            style: ButtonM3EStyle.outlined,
            shape: ButtonM3EShape.square,
            label: const Text('Disable Sharing'),
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.link_off),
            onPressed: _isLoading ? null : _disableSharing,
          )
        else
          ButtonM3E(
            style: ButtonM3EStyle.filled,
            shape: ButtonM3EShape.square,
            label: const Text('Enable Sharing'),
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.link),
            onPressed: _isLoading ? null : _enableSharing,
          ),
      ],
    );
  }
}
