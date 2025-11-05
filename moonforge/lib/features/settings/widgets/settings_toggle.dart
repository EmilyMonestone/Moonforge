import 'package:flutter/material.dart';

/// A settings tile with a toggle switch.
class SettingsToggle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leading;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggle({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading != null ? Icon(leading) : null,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
      onTap: () => onChanged(!value),
    );
  }
}
