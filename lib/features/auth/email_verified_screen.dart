import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/profile_service.dart';
import 'package:parkliapp/features/auth/complete_info_email_screen.dart';
import 'package:parkliapp/features/home/home_screen.dart';

class EmailVerifiedScreen extends StatefulWidget {
  const EmailVerifiedScreen({super.key});

  @override
  State<EmailVerifiedScreen> createState() => _EmailVerifiedScreenState();
}

class _EmailVerifiedScreenState extends State<EmailVerifiedScreen> {

  Future<void> _continue() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      // fallback
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/loginEmail',
        (route) => false,
      );
      return;
    }

    final profileService = ProfileService();
    final hasProfile =
        await profileService.hasProfileByEmail(user.email ?? '');

    if (!mounted) return;

    if (hasProfile) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              CompleteInfoEmailScreen(email: user.email ?? ''),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: Colors.green,
                  size: 90,
                ),
                const SizedBox(height: 24),
                Text(
                  AppData.translate(
                      'Email verified successfully',
                      'تم التحقق من البريد بنجاح'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF237D8C),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppData.translate(
                    'Your account has been activated. Continue to the app.',
                    'تم تفعيل حسابك بنجاح. تابع إلى التطبيق.',
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF237D8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      AppData.translate(
                          'Continue', 'متابعة'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}