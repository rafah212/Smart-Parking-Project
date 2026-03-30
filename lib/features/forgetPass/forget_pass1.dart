import 'package:flutter/material.dart';
import 'package:parkliapp/core/widgets/responsive_preview.dart';

class ForgotPassword1 extends StatelessWidget {
  const ForgotPassword1({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدمنا الـ Helper حقكم لضمان ظهور التصميم كجوال في الويب
    return ResponsivePreview(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            // هنا جعلنا العرض متجاوباً بدل 375 الثابتة
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                // --- الجزء العلوي (Top Bar) ---
                Positioned(
                  left: 0,
                  top: 44,
                  child: Container(
                    width: 375, // هذا العرض سيعالجه الـ ResponsivePreview تلقائياً
                    height: 58,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 0.5)),
                    ),
                    child: Center(
                      child: Text(
                        'Forgot Password?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF3E3E3E),
                          fontSize: 15,
                          fontFamily: 'Basis Grotesque Pro',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),

                // --- محتوى الصفحة الأساسي ---
                Positioned(
                  left: 0,
                  top: 102,
                  child: Container(
                    width: 375,
                    height: 676,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Stack(
                      children: [
                        // زر الرجوع (Back to Login)
                        Positioned(
                          left: 20,
                          top: 104,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context), // يرجع لصفحة اللوج ان
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.arrow_back_ios, size: 14, color: Color(0xFF237D8C)),
                                const Text(
                                  'Back to login',
                                  style: TextStyle(
                                    color: Color(0xFF237D8C),
                                    fontSize: 13,
                                    fontFamily: 'Red Hat Text',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // العنوان الأساسي
                        const Positioned(
                          left: 20,
                          top: 144,
                          child: Text(
                            'Let’s reset your password.',
                            style: TextStyle(
                              color: Color(0xFF237D8C),
                              fontSize: 28,
                              fontFamily: 'Basis Grotesque Pro',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                         // نص الوصف
                        const Positioned(
                          left: 20,
                          top: 190,
                          child: SizedBox(
                            width: 335,
                            child: Text(
                              'We will email you a link you can use to reset your password.',
                              style: TextStyle(color: Color(0xFF777777), fontSize: 14),
                            ),
                          ),
                        ),

                        // حقل الإدخال (Email Address)
                        Positioned(
                          left: 20,
                          top: 254,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email Address',
                                style: TextStyle(color: Color(0xFF237D8C), fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 335,
                                height: 48,
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE5E5E5)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const TextField( // أضفت لكِ حقل إدخال حقيقي هنا
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // زر Next
                        Positioned(
                          left: 20,
                          top: 348,
                          child: GestureDetector(
                            onTap: () {
                              // هنا سنربط الصفحة الثانية لاحقاً
                              print("Going to next page...");
                            },
                            child: Container(
                              width: 335,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF72ACB6),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: Text(
                                  'Next',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // تذييل الصفحة (Footer)
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            width: 375,
                            height: 65,
                            color: const Color(0xFFF3F3F3),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              '2025, PARKLI. All rights reserved',
                              style: TextStyle(color: Color(0xFF777777), fontSize: 14),
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
      ),
    );
  }
}