import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/auth_service.dart';
import 'package:parkliapp/features/auth/verify_email_otp_screen.dart';

class SignUpEmailScreen extends StatefulWidget {
  const SignUpEmailScreen({super.key});

  @override
  State<SignUpEmailScreen> createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends State<SignUpEmailScreen> {
  late final TextEditingController _emailController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final email = _emailController.text.trim().toLowerCase();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppData.translate(
              'Please enter your email',
              'يرجى إدخال البريد الإلكتروني',
            ),
          ),
        ),
      );
      return;
    }

    if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppData.translate(
              'Enter a valid email',
              'أدخل بريداً إلكترونياً صحيحاً',
            ),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final auth = AuthService();

      await auth.sendEmailOtp(
        email: email,
        shouldCreateUser: true,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyEmailOtpScreen(email: email),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      String message = e.toString().replaceFirst('Exception: ', '');

      if (message.contains('For security purposes')) {
        message = AppData.translate(
          'Please wait a little before requesting a new code',
          'يرجى الانتظار قليلًا قبل طلب رمز جديد',
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goBackToPhoneSignUp() {
    Navigator.pop(context);
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
              const _TopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppData.translate('Sign Up', 'إنشاء حساب'),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        AppData.translate(
                          'Email Address',
                          'البريد الإلكتروني',
                        ),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textAlign:
                            AppData.isArabic ? TextAlign.right : TextAlign.left,
                        decoration: InputDecoration(
                          hintText: AppData.translate(
                            'Enter email address',
                            'أدخل البريد الإلكتروني',
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9F9F9),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E5E5),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E5E5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF237D8C),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _InfoBox(
                        text: AppData.translate(
                          'We will send a verification code to your email',
                          'سنرسل رمز تحقق إلى بريدك الإلكتروني',
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA3D3DB),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            disabledBackgroundColor:
                                const Color(0xFFA3D3DB).withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  AppData.translate(
                                    'Send Code',
                                    'إرسال الرمز',
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const _OrDivider(),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: _goBackToPhoneSignUp,
                          icon: const Icon(
                            Icons.phone,
                            color: Color(0xFF237D8C),
                          ),
                          label: Text(
                            AppData.translate(
                              'Continue with Phone',
                              'الاستمرار باستخدام الجوال',
                            ),
                            style: const TextStyle(
                              color: Color(0xFF237D8C),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF237D8C),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const _BottomHandle(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          AppData.isArabic ? Icons.arrow_back_ios_new : Icons.arrow_back,
          color: const Color(0xFF237D8C),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: Color(0xFF237D8C),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF237D8C),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(0xFFE5E5E5),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            AppData.translate('OR', 'أو'),
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(0xFFE5E5E5),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

class _BottomHandle extends StatelessWidget {
  const _BottomHandle();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 20);
  }
}
