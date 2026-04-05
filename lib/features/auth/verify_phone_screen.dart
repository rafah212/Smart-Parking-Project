import 'package:flutter/material.dart';
import 'package:parkliapp/features/auth/complete_info_screen.dart';
import 'package:parkliapp/core/services/phone_auth_service.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    this.isAutoVerified = false,
  });

  final String phoneNumber;
  final String verificationId;
  final bool isAutoVerified;

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());

    if (widget.isAutoVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CompleteInfoScreen(
              phoneNumber: widget.phoneNumber,
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
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

    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.translate('Please enter the 6-digit code', 'يرجى إدخال الكود المكون من 6 أرقام'))),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final phoneAuth = PhoneAuthService();

      final isValid = await phoneAuth.verifyOtp(
        phoneNumber: widget.phoneNumber,
        code: code,
      );

      if (!mounted) return;

      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppData.translate('Invalid verification code', 'رمز التحقق غير صحيح'))),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CompleteInfoScreen(
            phoneNumber: widget.phoneNumber,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.translate('Verification failed: $e', 'فشل التحقق: $e'))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppData.translate('Resend will be enabled later', 'إعادة الإرسال ستكون متاحة قريباً')),
      ),
    );
  }

  void _skip() {}

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _TopBar(onSkip: _skip),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppData.translate('Verify your phone number', 'التحقق من رقم الجوال'),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        AppData.translate('Enter the code sent to ${widget.phoneNumber}', 'أدخل الكود المرسل إلى ${widget.phoneNumber}'),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: List.generate(
                          6,
                          (index) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: AppData.isArabic ? 0 : (index == 5 ? 0 : 10),
                                left: AppData.isArabic ? (index == 5 ? 0 : 10) : 0,
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  AppData.translate('Verify', 'تحقق'),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _resendCode,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF237D8C)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          ),
                          child: Text(
                            AppData.translate('Resend Code', 'إعادة إرسال الكود'),
                            style: const TextStyle(color: Color(0xFF237D8C)),
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
  const _TopBar({required this.onSkip});

  final VoidCallback onSkip;

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
      actions: [
        TextButton(
          onPressed: onSkip, 
          child: Text(
            AppData.translate('Skip', 'تخطي'),
            style: const TextStyle(color: Color(0xFF237D8C)),
          )
        ),
      ],
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
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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