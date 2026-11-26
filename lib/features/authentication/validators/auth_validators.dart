class AuthValidators {
  AuthValidators._();

  static final RegExp _emailRegex =
      RegExp(r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$');

  static String? fullName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your full name';
    if (v.length < 2) return 'Name is too short';
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your email address';
    if (!_emailRegex.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  /// Used on login: only requires that a password is present.
  static String? passwordRequired(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    return null;
  }

  /// Used on sign up / reset: enforces minimum security rules.
  static String? newPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Please enter a password';
    if (v.length < 8) return 'Use at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Add at least one uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Add at least one lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Add at least one number';
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() original) {
    return (value) {
      if (value == null || value.isEmpty) return 'Please confirm your password';
      if (value != original()) return 'Passwords do not match';
      return null;
    };
  }
}
