import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../validators/auth_validators.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;
  bool _done = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.instance
          .resetPassword(newPassword: _passwordController.text);
      if (mounted) setState(() => _done = true);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return AuthScaffold(
        child: AuthSuccessView(
          title: 'Password reset!',
          message: 'Your password has been updated. You can now log in with '
              'your new password.',
          primaryLabel: 'Back to Login',
          // Login is the root of the auth flow, so pop back to it.
          onPrimary: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      );
    }

    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthHeader(
              title: 'Create New Password',
              subtitle: 'Choose a secure new password. Use at least 8 '
                  'characters with upper and lower case letters and a number.',
              showBack: true,
            ),
            if (_error != null) AuthErrorBanner(message: _error!),
            CustomTextField(
              label: 'New password',
              hint: 'Enter new password',
              icon: Icons.lock_outline_rounded,
              controller: _passwordController,
              isPassword: true,
              validator: AuthValidators.newPassword,
              enabled: !_loading,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Confirm new password',
              hint: 'Re-enter new password',
              icon: Icons.lock_reset_rounded,
              controller: _confirmController,
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator:
                  AuthValidators.confirmPassword(() => _passwordController.text),
              enabled: !_loading,
              onSubmitted: _reset,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Reset Password',
              loading: _loading,
              onPressed: _reset,
            ),
          ],
        ),
      ),
    );
  }
}
