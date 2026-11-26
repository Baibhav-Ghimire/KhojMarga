import 'package:flutter/material.dart';

import '../../../core/navigation/auth_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../services/auth_service.dart';
import '../validators/auth_validators.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _loading = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      if (mounted) setState(() => _sent = true);
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
    if (_sent) {
      return AuthScaffold(
        child: AuthSuccessView(
          title: 'Check your email',
          message: 'We sent a password reset link to '
              '${_emailController.text.trim()}. Open it to create a new '
              'password.',
          primaryLabel: 'Return to Login',
          onPrimary: () => Navigator.of(context).pop(),
          // Preview only: in production the emailed link opens the reset
          // screen via a deep link / Firebase action URL.
          secondaryLabel: 'Preview reset screen',
          onSecondary: () => Navigator.of(context)
              .push(fadeRoute(const ResetPasswordScreen())),
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
              title: 'Forgot Password?',
              subtitle: "Don't worry! Enter your registered email address and "
                  "we'll help you reset your password.",
              showBack: true,
            ),
            if (_error != null) AuthErrorBanner(message: _error!),
            CustomTextField(
              label: 'Email address',
              hint: 'you@example.com',
              icon: Icons.mail_outline_rounded,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              validator: AuthValidators.email,
              enabled: !_loading,
              onSubmitted: _send,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Send Reset Link',
              loading: _loading,
              onPressed: _send,
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton.icon(
                onPressed:
                    _loading ? null : () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Return to Login'),
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
