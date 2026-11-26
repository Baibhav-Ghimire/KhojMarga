import 'dart:async';

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Authentication service layer.
///
/// IMPORTANT: no backend is connected yet.
/// - Email flows run against a simulated backend (short delay, always
///   succeeds) so the UI can be tested. Set [useSimulatedBackend] to false
///   once real calls are added; the methods will then throw until implemented.
/// - Google Sign-In is NOT simulated. It reports that configuration is
///   missing. See README_AUTH.md for the Firebase / Google setup steps.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const bool useSimulatedBackend = true;

  Future<void> _simulate() async {
    if (!useSimulatedBackend) {
      throw AuthException(
          'Authentication backend is not connected yet. Implement AuthService.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 1200));
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // TODO: FirebaseAuth.instance.signInWithEmailAndPassword(...)
    await _simulate();
  }

  Future<void> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // TODO: FirebaseAuth.instance.createUserWithEmailAndPassword(...)
    await _simulate();
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    // TODO: FirebaseAuth.instance.sendPasswordResetEmail(email: email)
    await _simulate();
  }

  Future<void> resetPassword({required String newPassword}) async {
    // TODO: FirebaseAuth.instance.confirmPasswordReset(code:..., newPassword:...)
    await _simulate();
  }

  Future<void> signInWithGoogle() async {
    // TODO (after Firebase + OAuth setup, see README_AUTH.md):
    //   final account = await GoogleSignIn.instance.authenticate();
    //   final auth = account.authentication;
    //   final credential = GoogleAuthProvider.credential(idToken: auth.idToken);
    //   await FirebaseAuth.instance.signInWithCredential(credential);
    throw AuthException(
        'Google Sign-In is not configured yet. Add Firebase and your Google '
        'OAuth credentials to enable it.');
  }
}
