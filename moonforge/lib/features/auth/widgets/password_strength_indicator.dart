import 'package:flutter/material.dart';
import 'package:moonforge/features/auth/utils/auth_validators.dart';

/// A widget that displays password strength visually.
///
/// Shows a progress bar and label indicating the strength of the password.
class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  final String password;

  @override
  Widget build(BuildContext context) {
    final strength = AuthValidators.getPasswordStrength(password);
    final label = AuthValidators.getPasswordStrengthLabel(strength);
    final theme = Theme.of(context);

    // Determine color based on strength
    Color getColor() {
      switch (strength) {
        case 0:
        case 1:
          return theme.colorScheme.error;
        case 2:
          return Colors.orange;
        case 3:
          return Colors.lightGreen;
        case 4:
          return Colors.green;
        default:
          return theme.colorScheme.outline;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: password.isEmpty ? 0 : (strength / 4),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: getColor(),
                minHeight: 4,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: getColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        if (password.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            _getPasswordHint(strength),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  String _getPasswordHint(int strength) {
    if (strength >= 4) return 'Great! Your password is strong.';
    if (strength >= 3) return 'Good password, but could be stronger.';
    if (strength >= 2) return 'Try adding uppercase, numbers, or symbols.';
    if (strength >= 1) return 'Password is too weak. Add more characters.';
    return 'Password must be at least 6 characters.';
  }
}
