import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';

class HomeHeader extends StatelessWidget {
  final bool hasNewNotifications;
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    this.hasNewNotifications = false,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        width: double.infinity,
        height: 110,
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                AppData.translate(
                  'Welcome back \nFind a parking spot nearby',
                  'أهلاً بك مجدداً \nابحث عن موقف سيارات قريب'
                ),
                style: const TextStyle(
                  color: Color(0xFFE5E5E5),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  letterSpacing: 0.7,
                ),
              ),
            ),
            GestureDetector(
              onTap: onNotificationTap, // تفعيل النقر
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF3C3F46),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.notifications, color: Colors.white, size: 20),
                    if (hasNewNotifications)
                      Positioned(
                        top: 10,
                        right: AppData.isArabic ? null : 10,
                        left: AppData.isArabic ? 10 : null,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF3C3F46), width: 1.5),
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
    );
  }
}