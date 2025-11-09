import 'package:flutter/material.dart';

/// A specialized text field for authentication forms.
///
/// Provides consistent styling, validation, and features like
/// password visibility toggle.
class AuthFormField extends StatefulWidget {
  const AuthFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    this.autofillHints,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;

  @override
  State<AuthFormField> createState() => _AuthFormFieldState();
}

class _AuthFormFieldState extends State<AuthFormField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscureText,
      keyboardType: widget.keyboardType,
      autofillHints: widget.autofillHints,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
