import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

import 'features/intro/intro_sequence_screen.dart';

import 'features/auth/login_email_screen.dart';
import 'features/forgotPass/change_pass.dart';
import 'features/home/home_screen.dart';

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
      home: const IntroSequenceScreen(),
      routes: {
        '/loginEmail': (_) => const LoginEmailScreen(),
        '/changePassword': (_) => const ChangePasswordScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
