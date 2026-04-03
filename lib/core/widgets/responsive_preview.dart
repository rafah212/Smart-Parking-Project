import 'package:flutter/material.dart';

class ResponsivePreview extends StatelessWidget {
  final Widget child;
  final String? title; // 

  const ResponsivePreview({
    super.key, 
    required this.child, 
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    // النظام الجديد: Scaffold مرن يفرش على أي شاشة
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. الهيدر الموحد (يظهر فقط إذا أرسلنا عنوان)
            if (title != null)
              Container(
                height: 70,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 10, top: 0, bottom: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Center(
                      child: Text(
                        title!,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 18, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // محتوى الصفحة اللي "يفرش" تلقائياً
            Expanded(
              child: child, // 
            ),
          ],
        ),
      ),
    );
  }
}