# Authentication Feature

## Overview

The Authentication feature provides user registration, login, logout, password reset, profile management, and email verification using Firebase Authentication.

## Architecture

### Services (`services/`)

- **`auth_service.dart`** - Core authentication operations wrapper for Firebase Auth
  - Sign in with email/password
  - Register new users
  - Password reset
  - Email verification
  - Profile updates (display name, photo URL)
  - Account deletion
  - Consistent error handling and logging

### Utilities (`utils/`)

- **`auth_validators.dart`** - Form validation utilities
  - Email format validation
  - Password strength validation
  - Password confirmation matching
  - Display name validation
  - Password strength scoring (0-4 scale)

- **`auth_error_handler.dart`** - Firebase Auth error translation
  - Maps Firebase error codes to user-friendly messages
  - Localized error strings
  - Helper methods for error type checking

### Widgets (`widgets/`)

- **`auth_form_field.dart`** - Specialized text field for auth forms
  - Consistent styling across auth screens
  - Built-in password visibility toggle
  - Validation support
  - Autofill hints integration

- **`password_strength_indicator.dart`** - Visual password strength meter
  - Real-time strength assessment
  - Color-coded progress bar
  - Helpful hints for improvement

- **`email_verification_banner.dart`** - Email verification prompt
  - Dismissible alert banner
  - Resend verification email action
  - Auto-hides when email is verified

### Views (`views/`)

- **`login_screen.dart`** - User login form
  - Email/password authentication
  - Form validation
  - Error handling with user-friendly messages
  - Navigation to register and forgot password

- **`register_screen.dart`** - New user registration
  - Email/password account creation
  - Password strength indicator
  - Password confirmation
  - Auto-login after successful registration

- **`forgot_password_screen.dart`** - Password reset flow
  - Email-based password reset
  - Success confirmation
  - Error handling

- **`profile_screen.dart`** - User profile management
  - View/edit display name
  - Email verification status and action
  - Account information display
  - Account deletion with confirmation

## Routes

All auth routes are defined in `lib/core/services/app_router.dart`:

- `/login` - Login screen
- `/login/register` - Registration screen
- `/login/forgot` - Forgot password screen
- `/profile` - User profile screen

## State Management

Authentication state is managed by `AuthProvider` (located in `lib/core/providers/auth_providers.dart`):

- Listens to Firebase auth state changes
- Provides `firebaseUser`, `isLoggedIn`, `isLoading` states
- Exposes auth methods: `signInWithEmailAndPassword`, `registerWithEmailAndPassword`, `signOut`, `sendPasswordResetEmail`

## Usage Examples

### Using AuthService

```dart
import 'package:moonforge/features/auth/services/auth_service.dart';

final authService = AuthService();

// Sign in
try {
  final user = await authService.signInWithEmailAndPassword(
    email: 'user@example.com',
    password: 'password123',
  );
  print('Signed in: ${user.email}');
} on FirebaseAuthException catch (e) {
  final message = AuthErrorHandler.getErrorMessage(e);
  // Show error to user
}

// Send email verification
await authService.sendEmailVerification();
```

### Using AuthValidators

```dart
import 'package:moonforge/features/auth/utils/auth_validators.dart';

TextFormField(
  controller: _emailController,
  validator: AuthValidators.validateEmail,
)

// Password strength
final strength = AuthValidators.getPasswordStrength('MyP@ssw0rd');
final label = AuthValidators.getPasswordStrengthLabel(strength);
```

### Using Auth Widgets

```dart
import 'package:moonforge/features/auth/widgets/auth_form_field.dart';
import 'package:moonforge/features/auth/widgets/password_strength_indicator.dart';

// Email field
AuthFormField(
  controller: _emailController,
  labelText: 'Email',
  prefixIcon: Icons.email_outlined,
  keyboardType: TextInputType.emailAddress,
  validator: AuthValidators.validateEmail,
)

// Password field with visibility toggle
AuthFormField(
  controller: _passwordController,
  labelText: 'Password',
  prefixIcon: Icons.lock_outline,
  isPassword: true,
  validator: AuthValidators.validatePassword,
)

// Password strength indicator
PasswordStrengthIndicator(
  password: _passwordController.text,
)
```

## Security Best Practices

1. **Password Requirements**
   - Minimum 6 characters (Firebase default)
   - Recommend 8+ characters with mixed case, numbers, and symbols

2. **Error Messages**
   - User-friendly messages that don't reveal sensitive information
   - Consistent error handling across all auth operations

3. **Email Verification**
   - Prompt users to verify email after registration
   - Show verification banner on profile and main screens
   - Easy resend functionality

4. **Account Protection**
   - Secure password reset flow via email
   - Account deletion requires confirmation
   - Recent authentication may be required for sensitive operations

## Testing

Auth components should be tested at multiple levels:

- **Unit tests** - Validators, error handlers, auth service methods
- **Widget tests** - Form fields, password strength indicator, banners
- **Integration tests** - Complete auth flows (login, register, reset)

## Future Enhancements

See `docs/missing/auth.md` for planned features:

- Social login (Google, Apple)
- Two-factor authentication
- Biometric authentication
- Session management
- Account linking
- Login history
- Security settings

## Dependencies

- `firebase_auth` - Firebase Authentication SDK
- `firebase_storage` - For profile photo storage
- `provider` - State management for AuthProvider
- `go_router` - Type-safe routing
- `toastification` - User notifications

## Related Files

- `lib/core/providers/auth_providers.dart` - AuthProvider state management
- `lib/core/widgets/auth_user_button.dart` - User profile button in app bar
- `lib/core/services/app_router.dart` - Auth route definitions
- `docs/missing/auth.md` - Feature requirements and missing implementations
