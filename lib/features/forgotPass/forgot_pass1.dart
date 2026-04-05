import 'package:flutter/material.dart';
import 'check_email.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class ForgotPassword1 extends StatefulWidget {
  const ForgotPassword1({super.key});

  @override
  State<ForgotPassword1> createState() => _ForgotPassword1State();
}

class _ForgotPassword1State extends State<ForgotPassword1> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void _handleNext() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.translate('Please enter your email', 'يرجى إدخال بريدك الإلكتروني'))),
      );
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ForgotPasswordCheckEmail(email: email),
      ),
    );
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
              // --- 1. الهيدر الموحد ---
              _CustomHeader(title: AppData.translate('Forgot Password?', 'نسيت كلمة المرور؟')),

              // --- 2. محتوى الصفحة المرن ---
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        AppData.translate('Let’s reset your password.', 'لنقم بإعادة تعيين كلمة المرور.'),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppData.translate(
                          'We will email you a link you can use to reset your password.',
                          'سنرسل لك رابطاً عبر البريد الإلكتروني يمكنك استخدامه لإعادة تعيين كلمة المرور.'
                        ),
                        style: const TextStyle(color: Color(0xFF777777), fontSize: 14),
                      ),
                      const SizedBox(height: 40),
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
                          hintText: AppData.translate('Enter your email', 'أدخل بريدك الإلكتروني'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- 3. البار السفلي (الزر والتذييل) ---
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: SizedBox(
      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF72ACB6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          AppData.translate('Next', 'التالي'),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    color: const Color(0xFFF3F3F3),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: AppData.isArabic ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(
                      AppData.translate('2026, PARKLI. All rights reserved', '٢٠٢٦، باركلي. جميع الحقوق محفوظة'),
                      style: const TextStyle(color: Color(0xFF777777), fontSize: 14),
                    ),
                  ),
                ],
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
              style: const TextStyle(color: Color(0xFF3E3E3E), fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}