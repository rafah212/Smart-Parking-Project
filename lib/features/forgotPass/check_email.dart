import 'package:flutter/material.dart';
import 'package:parkliapp/core/services/auth_service.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

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
        SnackBar(content: Text(AppData.translate('Password reset email sent again', 'تم إعادة إرسال بريد تعيين كلمة المرور'))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.translate('Failed to resend email: $e', 'فشل إعادة إرسال البريد: $e'))),
      );
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _CustomHeader(title: AppData.translate('Forgot Password?', 'نسيت كلمة المرور؟')),

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
                          size: 100, 
                          color: Color(0xFF237D8C),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        AppData.translate('Check your email', 'تحقق من بريدك'),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: AppData.translate('We sent a link to ', 'لقد أرسلنا رابطاً إلى '),
                              style: const TextStyle(color: Color(0xFF777777), fontSize: 16),
                            ),
                            TextSpan(
                              text: '${widget.email} ',
                              style: const TextStyle(
                                color: Color(0xFF237D8C),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: AppData.translate(
                                'to help set up a new password if you have an account with us.',
                                'لمساعدتك في تعيين كلمة مرور جديدة إذا كان لديك حساب معنا.'
                              ),
                              style: const TextStyle(color: Color(0xFF777777), fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppData.translate(
                          'Check your spam folder if you don’t see the email.',
                          'يرجى مراجعة ملف البريد المزعج (Spam) إذا لم تجد الرسالة.'
                        ),
                        style: const TextStyle(color: Color(0xFF999999), fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 50),
                      
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
                              : Text(
                                  AppData.translate('Resend Email Address', 'إعادة إرسال البريد الإلكتروني'),
                                  style: const TextStyle(
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
              
              // التذييل السفلي (Footer)
              Container(
                width: double.infinity,
                height: 60,
                color: const Color(0xFFF3F3F3),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                alignment: AppData.isArabic ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  AppData.translate('2026, PARKLI. All rights reserved', '٢٠٢٦، باركلي. جميع الحقوق محفوظة'),
                  style: const TextStyle(color: Color(0xFF777777), fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
            left: AppData.isArabic ? null : 10,
            right: AppData.isArabic ? 10 : null,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: Icon(
                AppData.isArabic ? Icons.arrow_back_ios_new : Icons.arrow_back_ios, 
                color: const Color(0xFF237D8C), 
                size: 20
              ),
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