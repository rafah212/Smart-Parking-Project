import 'package:flutter/material.dart';
import '../../app_data.dart'; 

class ResponsivePreview extends StatelessWidget {
  final Widget child;
  final String? title; 

  const ResponsivePreview({
    super.key, 
    required this.child, 
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    // 1. نغلف الشاشة كاملة باتجاه اللغة المختار من المخ
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // الهيدر الموحد
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
                    alignment: Alignment.center, // يضمن توسيط العنوان
                    children: [
                      // زر الرجوع: الآن مكانه يتغير تلقائياً (يمين أو يسار)
                      Positioned(
                        // إذا عربي يروح لليمين، إذا إنجليزي يروح لليسار
                        right: AppData.isArabic ? 10 : null,
                        left: AppData.isArabic ? null : 10,
                        top: 0, bottom: 0,
                        child: IconButton(
                          // أيقونة السهم تقلب اتجاهها حسب اللغة
                          icon: Icon(
                            AppData.isArabic ? Icons.arrow_back_ios_new : Icons.arrow_back_ios, 
                            color: Colors.white, 
                            size: 20
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      
                      // عنوان الصفحة
                      Text(
                        title!,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 18, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),

              // محتوى الصفحة
              Expanded(
                child: child, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}