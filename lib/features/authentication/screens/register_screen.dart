import 'package:flutter/material.dart';

import '../../../core/navigation/auth_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../services/auth_service.dart';
import '../validators/auth_validators.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;
  bool _googleLoading = false;
  bool _registered = false;
  String? _error;

  bool get _busy => _loading || _googleLoading;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_busy) return;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.instance.registerWithEmail(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) setState(() => _registered = true);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _google() async {
    if (_busy) return;
    setState(() {
      _googleLoading = true;
      _error = null;
    });
    try {
      await AuthService.instance.signInWithGoogle();
      if (!mounted) return;
      AuthNavigation.onAuthenticated(context);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Google sign-up failed. Try again.');
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_registered) {
      return AuthScaffold(
        child: AuthSuccessView(
          title: 'Account created!',
          message: 'Welcome to Margaखोज. Log in to start planning your '
              'next trek.',
          primaryLabel: 'Go to Login',
          onPrimary: () => Navigator.of(context).pop(),
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
              title: 'Create Your Account',
              subtitle: 'Start your next trekking adventure with us.',
              showBack: true,
            ),
            if (_error != null) AuthErrorBanner(message: _error!),
            CustomTextField(
              label: 'Full name',
              hint: 'Your full name',
              icon: Icons.person_outline_rounded,
              controller: _nameController,
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.name],
              validator: AuthValidators.fullName,
              enabled: !_busy,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email address',
              hint: 'you@example.com',
              icon: Icons.mail_outline_rounded,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              validator: AuthValidators.email,
              enabled: !_busy,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Password',
              hint: 'Min. 8 chars, upper, lower & number',
              icon: Icons.lock_outline_rounded,
              controller: _passwordController,
              isPassword: true,
              validator: AuthValidators.newPassword,
              enabled: !_busy,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Confirm password',
              hint: 'Re-enter your password',
              icon: Icons.lock_reset_rounded,
              controller: _confirmController,
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator:
                  AuthValidators.confirmPassword(() => _passwordController.text),
              enabled: !_busy,
            ),
            const SizedBox(height: 12),
            FormField<bool>(
              initialValue: false,
              validator: (v) => (v ?? false)
                  ? null
                  : 'You must accept the Terms and Conditions',
              builder: (state) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: state.value ?? false,
                          onChanged: _busy ? null : state.didChange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 13,
                                height: 1.4,
                              ),
                              children: [
                                TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: TextStyle(
                                    color: AppColors.orange,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: AppColors.orange,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 32),
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(
                            color: AppColors.error, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Create Account',
              loading: _loading,
              onPressed: _register,
            ),
            const SizedBox(height: 24),
            const AuthDivider(),
            const SizedBox(height: 24),
            GoogleSignInButton(
              label: 'Sign up with Google',
              loading: _googleLoading,
              onPressed: _google,
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Existing account?',
                  style: TextStyle(color: AppColors.secondaryText),
                ),
                TextButton(
                  onPressed: _busy ? null : () => Navigator.of(context).pop(),
                  child: const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
