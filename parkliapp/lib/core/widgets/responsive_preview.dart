import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsivePreview extends StatelessWidget {
  final Widget child;
  const ResponsivePreview({super.key, required this.child});

  static const double phoneW = 375; // iPhone 11 logical size
  static const double phoneH = 812;

  bool _isDesktopOrWeb(BuildContext context) {
    // Web: always true for kIsWeb
    // Desktop: windows/mac/linux
    final platformDesktop = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.linux);

    // Optional: treat large screens as "preview"
    final isLargeScreen = MediaQuery.of(context).size.width >= 700;

    return kIsWeb || platformDesktop || isLargeScreen;
  }

  @override
  Widget build(BuildContext context) {
    if (_isDesktopOrWeb(context)) {
      // ✅ Laptop/Web preview: show as iPhone frame
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: SizedBox(
            width: phoneW,
            height: phoneH,
            child: child,
          ),
        ),
      );
    }

    // ✅ Real phones/tablets: full screen
    return child;
  }
}