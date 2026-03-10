import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على عرض الشاشة الحالي لجعل التصميم متجاوباً
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: 812, // يمكنك تغييره لـ MediaQuery.of(context).size.height إذا أردت كامل الارتفاع
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // --- خلفية الإشعار الأول (النشط) ليمتد بعرض الشاشة ---
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 142,
                    child: Container(
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F6FF),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 5,
                              color: const Color(0xA3237D8C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- قائمة الإشعارات ---
                  _buildNotificationItem(
                    top: 157,
                    title: 'Your car is parked',
                    subtitle: 'The time will be counted down',
                    time: 'Now',
                  ),
                  _buildNotificationItem(
                    top: 258,
                    title: 'You have arrived',
                    subtitle: 'Please scan the code on the parking...',
                    time: '6 min',
                  ),
                  _buildNotificationItem(
                    top: 344,
                    title: 'Successful transaction',
                    subtitle: '1 parking slot already booked',
                    time: '1 hour',
                  ),

                  // --- الهيدر العلوي (Header) ---
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 110,
                      decoration: const ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.50, -0.00),
                          end: Alignment(0.50, 1.00),
                          colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                      ),
                      child: SafeArea(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // سهم الرجوع
                            Positioned(
                              left: 10,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                            // عنوان الصفحة
                            const Text(
                              'Notifications',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget مساعد لبناء الإشعار بشكل يمتد بعرض الشاشة
  Widget _buildNotificationItem({
    required double top,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Positioned(
      left: 20, // الهامش من اليسار
      right: 20, // الهامش من اليمين (يجعلها تمتد)
      top: top,
      child: SizedBox(
        height: 65,
        child: Stack(
          children: [
            // النص الرئيسي
            Positioned(
              left: 0,
              top: 0,
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF237D8C),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Lato',
                ),
              ),
            ),
            // النص الفرعي
            Positioned(
              left: 0,
              top: 30,
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF677191),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Lato',
                ),
              ),
            ),
            // الوقت (أقصى اليمين)
            Positioned(
              right: 0,
              top: 5,
              child: Text(
                time,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF237D8C),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Lato',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}