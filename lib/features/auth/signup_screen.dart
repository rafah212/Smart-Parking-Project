import 'package:flutter/material.dart';
import 'package:parkliapp/features/auth/signup_email_screen.dart';
import 'package:parkliapp/features/auth/verify_phone_screen.dart';
import 'package:parkliapp/core/services/phone_auth_service.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final rawPhone = _phoneController.text.trim();

    if (rawPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.translate('Please enter your mobile number', 'يرجى إدخال رقم الجوال'))),
      );
      return;
    }

    String digitsOnly = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.startsWith('0')) {
      digitsOnly = digitsOnly.substring(1);
    }

    if (digitsOnly.length != 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.translate('Enter a valid Saudi mobile number', 'أدخل رقم جوال سعودي صحيح'))),
      );
      return;
    }

    final phoneNumber = '+966$digitsOnly';

    setState(() {
      _isLoading = true;
    });

    try {
      final phoneAuth = PhoneAuthService();
      await phoneAuth.sendOtp(phoneNumber: phoneNumber);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyPhoneScreen(
            phoneNumber: phoneNumber,
            verificationId: '',
            isAutoVerified: false,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.translate('Failed to send OTP: $e', 'فشل في إرسال رمز التحقق: $e'))),
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
                          letterSpacing: -0.84,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        AppData.translate('Mobile Number', 'رقم الجوال'),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.36,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const _CountryCodeField(),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textAlign: AppData.isArabic ? TextAlign.right : TextAlign.left,
                              decoration: InputDecoration(
                                hintText: '5XXXXXXXX',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF777777),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 15,
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const _OtpInfoBox(),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xA3237D8C),
                            foregroundColor: Colors.white,
                            elevation: 0,
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
                                  AppData.translate('Continue', 'استمرار'),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.39,
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignUpEmailScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFF237D8C),
                            size: 20,
                          ),
                          label: Text(
                            AppData.translate('Continue with Email', 'الاستمرار عبر البريد الإلكتروني'),
                            style: const TextStyle(
                              color: Color(0xFF237D8C),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.39,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF237D8C),
                            side: const BorderSide(color: Color(0xFF237D8C)),
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
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              AppData.isArabic ? Icons.arrow_back_ios_new : Icons.arrow_back_ios_new,
              color: const Color(0xFF237D8C),
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF237D8C),
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            label: Text(
              AppData.translate('Skip', 'تخطي'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.42,
              ),
            ),
            icon: Icon(
              AppData.isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios, 
              size: 14
            ),
            iconAlignment: AppData.isArabic ? IconAlignment.start : IconAlignment.end,
          ),
        ],
      ),
    );
  }
}

class _CountryCodeField extends StatelessWidget {
  const _CountryCodeField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 11, backgroundColor: Color(0xFFE5E5E5)),
          SizedBox(width: 6),
          Text(
            '+966',
            style: TextStyle(
              color: Color(0xFF19515B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, color: Color(0xFF19515B), size: 18),
        ],
      ),
    );
  }
}

class _OtpInfoBox extends StatelessWidget {
  const _OtpInfoBox();

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
          const Icon(Icons.info_outline, color: Color(0xFF237D8C), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppData.translate(
                'You will receive an OTP code from ParkLi to confirm your number',
                'ستصلك رسالة نصية تحتوي على رمز التحقق لتأكيد رقمك'
              ),
              style: const TextStyle(
                color: Color(0xFF237D8C),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.39,
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
        const Expanded(child: Divider(color: Color(0xFFE5E5E5), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            AppData.translate('OR', 'أو'),
            style: const TextStyle(
              color: Color(0xFF777777),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.36,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE5E5E5), thickness: 1)),
      ],
    );
  }
}

class _BottomHandle extends StatelessWidget {
  const _BottomHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      color: Colors.white,
      alignment: const Alignment(0, 0.3),
      child: Container(
        width: 134,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}