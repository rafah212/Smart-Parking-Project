import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/auth_service.dart';
import 'package:parkliapp/core/services/local_session_service.dart';
import 'package:parkliapp/core/services/profile_service.dart';
import 'package:parkliapp/features/auth/complete_info_email_screen.dart';
import 'package:parkliapp/features/home/home_screen.dart';

class VerifyEmailOtpScreen extends StatefulWidget {
  const VerifyEmailOtpScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<VerifyEmailOtpScreen> createState() => _VerifyEmailOtpScreenState();
}

class _VerifyEmailOtpScreenState extends State<VerifyEmailOtpScreen> {
  static const int _otpLength = 8;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  bool _isLoading = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _controllers.map((e) => e.text).join();

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < _focusNodes.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  void _onBackspace(String value, int index) {
    if (value.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyCode() async {
    final code = _otpCode;

    if (code.length != _otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppData.translate(
              'Please enter the 8-digit code',
              'يرجى إدخال الكود المكون من 8 أرقام',
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

      final res = await auth.verifyEmailOtp(
        email: widget.email,
        otp: code,
      );

      if (res.user == null) {
        throw Exception(
          AppData.translate(
            'Verification failed',
            'فشل التحقق',
          ),
        );
      }

      await LocalSessionService().saveEmailSession();

      final profileService = ProfileService();
      final hasProfile = await profileService.hasProfileByEmail(widget.email);

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
            builder: (_) => CompleteInfoEmailScreen(email: widget.email),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      String message = e.toString().replaceFirst('Exception: ', '');

      if (message.toLowerCase().contains('expired')) {
        message = AppData.translate(
          'The code has expired. Please request a new one.',
          'انتهت صلاحية الرمز. يرجى طلب رمز جديد.',
        );
      } else if (message.toLowerCase().contains('invalid')) {
        message = AppData.translate(
          'Incorrect code. Please try again.',
          'الرمز غير صحيح. يرجى المحاولة مرة أخرى.',
        );
      }

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

  Future<void> _resendCode() async {
    setState(() {
      _isResending = true;
    });

    try {
      final auth = AuthService();

      await auth.sendEmailOtp(
        email: widget.email,
        shouldCreateUser: true,
      );

      for (final controller in _controllers) {
        controller.clear();
      }

      if (_focusNodes.isNotEmpty) {
        _focusNodes.first.requestFocus();
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppData.translate(
              'Code resent successfully',
              'تمت إعادة إرسال الرمز بنجاح',
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
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
                        AppData.translate(
                          'Verify your email',
                          'التحقق من البريد الإلكتروني',
                        ),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        AppData.translate(
                          'Enter the code sent to ${widget.email}',
                          'أدخل الرمز المرسل إلى ${widget.email}',
                        ),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: List.generate(
                          _otpLength,
                          (index) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: AppData.isArabic
                                    ? 0
                                    : (index == _otpLength - 1 ? 0 : 8),
                                left: AppData.isArabic
                                    ? (index == _otpLength - 1 ? 0 : 8)
                                    : 0,
                              ),
                              child: _OtpInputBox(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    _onBackspace(value, index);
                                  } else {
                                    _onOtpChanged(value, index);
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verifyCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF237D8C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.2,
                                  ),
                                )
                              : Text(
                                  AppData.translate('Verify', 'تحقق'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _isResending ? null : _resendCode,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF237D8C),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: _isResending
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF237D8C),
                                  ),
                                )
                              : Text(
                                  AppData.translate(
                                    'Resend Code',
                                    'إعادة إرسال الرمز',
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF237D8C),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _OtpInputBox extends StatelessWidget {
  const _OtpInputBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLength: 1,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF237D8C)),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
