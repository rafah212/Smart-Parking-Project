import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

import 'features/intro/intro_sequence_screen.dart';
import 'features/auth/email_verified_screen.dart';
import 'features/auth/login_email_screen.dart';

class App extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const App({
    super.key,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,

      // أول شاشة
      home: const IntroSequenceScreen(),

      // Routes
      routes: {
        '/loginEmail': (_) => const LoginEmailScreen(),
        '/emailVerified': (_) => const EmailVerifiedScreen(),
      },
    );
  }
}