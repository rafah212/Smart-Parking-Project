import 'package:flutter/material.dart';
// تأكد من أن المسار هنا يشير إلى ملف النوتفيكيشن الذي أنشأته
import '../notifications.dart'; 

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const Expanded(
                child: Text(
                  'Welcome back 👋\nFind a parking spot nearby',
                  style: TextStyle(
                    color: Color(0xFFE5E5E5),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
              // --- تم تغليف حاوية الجرس بـ GestureDetector للربط ---
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
                      Positioned(
                        top: 8,
                        right: 8,
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
              // ------------------------------------------------
            ],
          ),
        ],
      ),
    );
  }
}

class _FakeStatusBar extends StatelessWidget {
  const _FakeStatusBar();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '9:41',
          style: TextStyle(
            color: Colors.black, // ملاحظة: قد يحتاج الفريق لتغيير هذا اللون للأبيض ليظهر فوق التدرج الداكن
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            Icon(Icons.signal_cellular_alt, size: 16, color: Colors.black),
            SizedBox(width: 4),
            Icon(Icons.wifi, size: 16, color: Colors.black),
            SizedBox(width: 4),
            Icon(Icons.battery_full, size: 18, color: Colors.black),
          ],
        ),
      ],
    );
  }
}