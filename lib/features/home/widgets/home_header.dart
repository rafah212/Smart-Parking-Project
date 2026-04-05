import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ
import '../notifications.dart'; 

class HomeHeader extends StatelessWidget {
  // إضافة المتغير للتحكم في ظهور النقطة الحمراء من الخارج
  final bool hasNewNotifications;

  const HomeHeader({
    super.key,
    this.hasNewNotifications = false, // القيمة الافتراضية هي عدم وجود تنبيهات
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        width: double.infinity,
        height: 138,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        child: Column(
          children: [
            const _FakeStatusBar(),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      height: 1.35,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Notifications()),
                    );
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3C3F46),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 18,
                        ),
                        // النقطة الحمراء لا تظهر إلا إذا كان هناك تنبيهات جديدة
                        if (hasNewNotifications)
                          Positioned(
                            top: 8,
                            right: AppData.isArabic ? null : 8,
                            left: AppData.isArabic ? 8 : null,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FakeStatusBar extends StatelessWidget {
  const _FakeStatusBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '9:41',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            const Icon(Icons.signal_cellular_alt, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            const Icon(Icons.wifi, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            const Icon(Icons.battery_full, size: 18, color: Colors.white),
          ],
        ),
      ],
    );
  }
}