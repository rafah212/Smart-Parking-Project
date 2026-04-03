import 'package:flutter/material.dart';
import 'package:parkliapp/core/services/auth_service.dart';

class ForgotPasswordCheckEmail extends StatefulWidget {
  final String email;

  const ForgotPasswordCheckEmail({
    super.key,
    required this.email,
  });

  @override
  State<ForgotPasswordCheckEmail> createState() => _ForgotPasswordCheckEmailState();
}

class _ForgotPasswordCheckEmailState extends State<ForgotPasswordCheckEmail> {
  bool _isResending = false;

  Future<void> _resendEmail() async {
    setState(() => _isResending = true);
    try {
      await AuthService().sendPasswordResetEmail(email: widget.email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent again')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend email: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // شلنا الـ ResponsivePreview عشان الصفحة تأخذ حجم الشاشة كاملة
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- الهيدر الموحد لضمان التناسق ---
            _CustomHeader(title: 'Forgot Password?'),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    const Center(
                      child: Icon(
                        Icons.mark_email_read_outlined,
                        size: 100, // كبرنا الأيقونة شوي لتناسب شاشة اللابتوب
                        color: Color(0xFF237D8C),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Check your email',
                      style: TextStyle(
                        color: Color(0xFF237D8C),
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'We sent a link to ',
                            style: TextStyle(color: Color(0xFF777777), fontSize: 16),
                          ),
                          TextSpan(
                            text: '${widget.email} ',
                            style: const TextStyle(
                              color: Color(0xFF237D8C), // غيرنا اللون للتمييز
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: 'to help set up a new password if you have an account with us.',
                            style: TextStyle(color: Color(0xFF777777), fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Check your spam folder if you don’t see the email.',
                      style: TextStyle(color: Color(0xFF999999), fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 50),
                    
                    // زر إعادة الإرسال بعرض كامل
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isResending ? null : _resendEmail,
  style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF237D8C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: _isResending
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Resend Email Address',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // --- التذييل السفلي (Footer) ---
            Container(
              width: double.infinity,
              height: 60,
              color: const Color(0xFFF3F3F3),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.centerLeft,
              child: const Text(
                '2025, PARKLI. All rights reserved',
                style: TextStyle(color: Color(0xFF777777), fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// الهيدر الموحد المستعمل في كل صفحاتك الآن
class _CustomHeader extends StatelessWidget {
  final String title;
  const _CustomHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 0.5)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF237D8C), size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Text(
              title,
              style: const TextStyle(color: Color(0xFF3E3E3E), fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}