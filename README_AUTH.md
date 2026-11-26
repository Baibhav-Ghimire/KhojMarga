# Margaखोज authentication module

Copy the `lib/` folder contents into your project's `lib/` (merge; do not
replace your own main.dart).

## Wire it up in main.dart
```dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/auth_navigation.dart';
import 'features/authentication/screens/login_screen.dart';

void main() {
  AuthNavigation.onAuthenticated = (context) {
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false);
  };
  runApp(const MargaKhojApp());
}

class MargaKhojApp extends StatelessWidget {
  const MargaKhojApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Margaखोज',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const LoginScreen(), // must be the root of the auth flow
      );
}
```
No new pub dependencies are required for the UI.

## Enabling real Google Sign-In (Firebase)
1. Create a Firebase project; add the Android app with your applicationId.
2. Add your debug + release SHA-1 / SHA-256 (`./gradlew signingReport`).
3. Enable Authentication > Sign-in method > Google; enable Email/Password too.
4. Download google-services.json into android/app/.
5. Run `flutterfire configure`.
6. `flutter pub add firebase_core firebase_auth google_sign_in`
7. Call `await Firebase.initializeApp(...)` in main().
8. Implement the TODOs in `services/auth_service.dart` (they match the
   google_sign_in 7.x API; check the package docs for your installed version).
9. Set `useSimulatedBackend = false`.
