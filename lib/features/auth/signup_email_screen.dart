import 'package:flutter/material.dart';
import 'package:parkliapp/core/services/auth_service.dart';
import 'package:parkliapp/features/auth/complete_info_email_screen.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class SignUpEmailScreen extends StatefulWidget {
  const SignUpEmailScreen({super.key});

  @override
  State<SignUpEmailScreen> createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends State<SignUpEmailScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.translate('Please enter email and password', 'يرجى إدخال البريد الإلكتروني وكلمة المرور'))),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final auth = AuthService();

      final res = await auth.signUpWithEmail(
        email: email,
        password: password,
      );

      if (res.user == null) {
        throw Exception(AppData.translate('Signup failed', 'فشل إنشاء الحساب'));
      }

      if (!mounted) return;

      if (res.session == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppData.translate('Check your email to verify your account', 'تحقق من بريدك الإلكتروني لتفعيل حسابك')),
          ),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CompleteInfoEmailScreen(email: email),
        ),
      );
    } catch (e) {
      String message = e.toString();

      if (message.contains('User already registered')) {
        message = AppData.translate('This email is already registered', 'هذا البريد الإلكتروني مسجل مسبقاً');
      } else {
        message = AppData.translate('Signup failed: $message', 'فشل التسجيل: $message');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
                        AppData.translate('Email Address', 'البريد الإلكتروني'),
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
                        textAlign: AppData.isArabic ? TextAlign.right : TextAlign.left,
                        decoration: InputDecoration(
                          hintText: AppData.translate('Enter email address', 'أدخل البريد الإلكتروني'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        AppData.translate('Password', 'كلمة المرور'),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        textAlign: AppData.isArabic ? TextAlign.right : TextAlign.left,
                        decoration: InputDecoration(
                          hintText: AppData.translate('Enter password', 'أدخل كلمة المرور'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA3D3DB),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  AppData.translate('Continue', 'استمرار'),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.phone),
                          label: Text(
                            AppData.translate('Continue with Phone', 'الاستمرار باستخدام الجوال'),
                            style: const TextStyle(color: Color(0xFF237D8C)),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF237D8C)),
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

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            AppData.translate('OR', 'أو'),
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        const Expanded(child: Divider()),
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