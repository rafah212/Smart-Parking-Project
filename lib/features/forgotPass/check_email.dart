import 'package:flutter/material.dart';
import 'package:parkliapp/core/widgets/responsive_preview.dart';

class ForgotPasswordCheckEmail extends StatelessWidget {
  const ForgotPasswordCheckEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePreview(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF237D8C), size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Forgot Password?',
            style: TextStyle(
              color: Color(0xFF3E3E3E),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.5),
            child: Container(color: const Color(0xFFE5E5E5), height: 0.5),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // أيقونة بسيطة (اختياري) أو مساحة كما في التصميم
                    const Icon(Icons.mark_email_read_outlined, size: 50, color: Color(0xFF237D8C)),
                    const SizedBox(height: 24),
                    const Text(
                      'Check your email',
                      style: TextStyle(
                        color: Color(0xFF237D8C),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'We sent a link to ',
                            style: TextStyle(color: Color(0xFF777777), fontSize: 14),
                          ),
                          TextSpan(
                            text: 'test@testemail.com ', // هنا لاحقاً بنخليها تاخذ الإيميل الحقيقي
                            style: TextStyle(color: Color(0xFF777777), fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'to help set up a new password if you have an account with us.',
                            style: TextStyle(color: Color(0xFF777777), fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Check your spam folder if you don’t see the email.',
                      style: TextStyle(color: Color(0xFF777777), fontSize: 14),
                    ),
                    const SizedBox(height: 40),
                    // زر إعادة الإرسال
                    GestureDetector(
                      onTap: () {
                        print("Resending Email...");
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF237D8C),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text(
                            'Resend Email Address',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                  ),
              ),
            ),
            // تذييل الصفحة (Footer)
            Container(
              width: double.infinity,
              height: 65,
              color: const Color(0xFFF3F3F3),
              padding: const EdgeInsets.symmetric(horizontal: 20),
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