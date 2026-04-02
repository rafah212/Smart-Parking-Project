import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bpvrhoqnwjgrnuevlofk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJwdnJob3Fud2pncm51ZXZsb2ZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUwNzM1MDksImV4cCI6MjA5MDY0OTUwOX0.thlqWQUzr9v0Kj9-wIaubmwDiZ5GNAs4dkGkLXfCSMM',
  );

  try {
    final response =
        await Supabase.instance.client.from('users').select().limit(1);
    debugPrint('Supabase connected: $response');
  } catch (e) {
    debugPrint('Supabase connection error: $e');
  }

  runApp(const AppEntry());
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _listenToDeepLinks();
  }

  Future<void> _listenToDeepLinks() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        await _handleUri(initialUri);
      }
    } catch (e) {
      debugPrint('Initial deep link error: $e');
    }

    _sub = _appLinks.uriLinkStream.listen(
      (uri) async {
        await _handleUri(uri);
      },
      onError: (error) {
        debugPrint('Deep link stream error: $error');
      },
    );
  }

  Future<void> _handleUri(Uri uri) async {
    debugPrint('Deep link received: $uri');

    if (uri.scheme == 'parkliapp' && uri.host == 'auth-callback') {
      try {
        await Supabase.instance.client.auth.refreshSession();
      } catch (e) {
        debugPrint('Session refresh error: $e');
      }

      if (!mounted) return;

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/emailVerified',
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return App(navigatorKey: navigatorKey);
  }
}