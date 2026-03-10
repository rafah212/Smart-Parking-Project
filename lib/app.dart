import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

import 'features/intro/intro_sequence_screen.dart';
//import 'package:parkliapp/features/home/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const IntroSequenceScreen(),
    );
  }
}
