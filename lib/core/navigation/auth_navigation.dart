import 'package:flutter/material.dart';

/// Subtle fade transition used between all authentication screens.
Route<T> fadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

class AuthNavigation {
  AuthNavigation._();

  /// Called after a successful login / Google sign-in.
  /// Set this in main.dart to navigate to your real home screen, e.g.
  /// AuthNavigation.onAuthenticated = (ctx) =>
  ///     Navigator.of(ctx).pushAndRemoveUntil(
  ///         MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false);
  static void Function(BuildContext context) onAuthenticated = (context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signed in. Connect AuthNavigation.onAuthenticated '
            'to your home screen.'),
      ),
    );
  };
}
