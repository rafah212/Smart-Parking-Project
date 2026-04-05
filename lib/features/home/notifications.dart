import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                // --- خلفية الإشعار النشط (الأول) ---
                Positioned(
                  left: 0,
                  right: 0,
                  top: 130,
                  child: Container(
                    height: 90,
                    decoration: const BoxDecoration(color: Color(0xFFF3F6FF)),
                    child: Stack(
                      children: [
                        Positioned(
                          // الشريط الجانبي يقلب مكانه حسب اللغة
                          right: AppData.isArabic ? 0 : null,
                          left: AppData.isArabic ? null : 0,
                          top: 0, bottom: 0,
                          child: Container(
                            width: 5,
                            color: const Color(0xA3237D8C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- قائمة الإشعارات المعربة ---
                _buildNotificationItem(
                  top: 145,
                  title: AppData.translate('Your car is parked', 'تم ركن سيارتك'),
                  subtitle: AppData.translate('The time will be counted down', 'بدأ الآن احتساب وقت الوقوف'),
                  time: AppData.translate('Now', 'الآن'),
                ),
                _buildNotificationItem(
                  top: 245,
                  title: AppData.translate('You have arrived', 'لقد وصلت للموقع'),
                  subtitle: AppData.translate('Please scan the code on the parking...', 'يرجى مسح الرمز الموجود عند الموقف...'),
                  time: AppData.translate('6 min', '٦ دقائق'),
                ),
                _buildNotificationItem(
                  top: 330,
                  title: AppData.translate('Successful transaction', 'عملية دفع ناجحة'),
                  subtitle: AppData.translate('1 parking slot already booked', 'تم حجز موقف واحد بنجاح'),
                  time: AppData.translate('1 hour', '١ ساعة'),
                ),

                // --- الهيدر العلوي (Header) ---
                Positioned(
                  left: 0, right: 0, top: 0,
                  child: Container(
                    height: 110,
                    decoration: const ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
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
                          Positioned(
                            // سهم الرجوع يقلب اتجاهه حسب اللغة
                            right: AppData.isArabic ? 10 : null,
                            left: AppData.isArabic ? null : 10,
                            child: IconButton(
                              icon: Icon(
                                AppData.isArabic ? Icons.arrow_forward : Icons.arrow_back, 
                                color: Colors.white
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Text(
                            AppData.translate('Notifications', 'الإشعارات'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
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
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required double top,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Positioned(
      left: 20, right: 20, top: top,
      child: SizedBox(
        height: 70,
        child: Stack(
          children: [
            // العنوان (يمين في العربي، يسار في الإنجليزي)
            Positioned(
              right: AppData.isArabic ? 0 : null,
              left: AppData.isArabic ? null : 0,
              top: 0,
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF237D8C),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // النص الفرعي
            Positioned(
              right: AppData.isArabic ? 0 : null,
              left: AppData.isArabic ? null : 0,
              top: 30,
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF677191),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // الوقت (يسار في العربي، يمين في الإنجليزي)
            Positioned(
              left: AppData.isArabic ? 0 : null,
              right: AppData.isArabic ? null : 0,
              top: 5,
              child: Text(
                time,
                style: const TextStyle(
                  color: Color(0xFF237D8C),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}