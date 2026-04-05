import 'package:flutter/material.dart';
import 'login_email_screen.dart';
import 'verify_phone_screen.dart';
import 'package:parkliapp/core/services/phone_auth_service.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  String selectedCode = '+966';
  bool isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String _buildFullPhoneNumber() {
    String phone = _phoneController.text.trim();
    phone = phone.replaceAll(' ', '').replaceAll('-', '');

    if (selectedCode == '+966' && phone.startsWith('0')) {
      phone = phone.substring(1);
    }

    return '$selectedCode$phone';
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyPhoneScreen(
          phoneNumber: _buildFullPhoneNumber(),
          verificationId: 'temp',
          isAutoVerified: false,
        ),
      ),
    );
  }

  void _goToEmailLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginEmailScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF237D8C);
    const borderColor = Color(0xFFE5E5E5);
    const fieldBg = Color(0xFFF9F9F9);

    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              AppData.isArabic ? Icons.arrow_back_ios_new : Icons.arrow_back_ios_new,
              color: primaryColor,
              size: 20,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    AppData.translate('Login to your account', 'تسجيل الدخول إلى حسابك'),
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    AppData.translate('Mobile Number', 'رقم الجوال'),
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 95,
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCode,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: primaryColor,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: '+966',
                                child: Text('+966'),
                              ),
                              DropdownMenuItem(
                                value: '+971',
                                child: Text('+971'),
                              ),
                              DropdownMenuItem(
                                value: '+20',
                                child: Text('+20'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedCode = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textAlign: AppData.isArabic ? TextAlign.right : TextAlign.left,
                          decoration: InputDecoration(
                            hintText: '0567891234',
                            filled: true,
                            fillColor: fieldBg,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: primaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppData.translate('Please enter your mobile number', 'يرجى إدخال رقم الجوال');
                            }
                            final phone = value.trim();
                            if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
                              return AppData.translate('Phone number must contain numbers only', 'يجب أن يحتوي الرقم على أرقام فقط');
                            }
                            if (phone.length < 9 || phone.length > 10) {
                              return AppData.translate('Enter a valid phone number', 'أدخل رقم جوال صحيح');
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor.withOpacity(0.7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        disabledBackgroundColor: primaryColor.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              AppData.translate('Login', 'تسجيل الدخول'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: borderColor, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          AppData.translate('OR', 'أو'),
                          style: const TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: borderColor, thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: _goToEmailLogin,
                      icon: const Icon(Icons.email_outlined, color: primaryColor),
                      label: Text(
                        AppData.translate('Login with Email', 'الدخول عبر البريد الإلكتروني'),
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: primaryColor),
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
        ),
      ),
    );
  }
}