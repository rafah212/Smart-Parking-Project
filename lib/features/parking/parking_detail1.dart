import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ لربط البيانات الحقيقية
import 'parking_detail2.dart';
import 'payment_method.dart';

class ParkingDetail1 extends StatefulWidget {
  const ParkingDetail1({super.key});

  @override
  State<ParkingDetail1> createState() => _ParkingDetail1State();
}

class _ParkingDetail1State extends State<ParkingDetail1> {
  // 1. جعل القيمة الابتدائية مرتبطة بالمخ (AppData)
  double _currentValue = AppData.durationHours.toDouble();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBFB),
        body: SafeArea(
          child: Column(
            children: [
              // --- الهيدر المعرب ---
              _ParkingHeader(title: AppData.translate('Parking detail', 'تفاصيل الموقف')),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // صورة الموقف
                      Center(
                        child: Image.asset(
                          'assets/images/parkdetial.png',
                          height: 220,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // عنوان اختيار الوقت
                      Text(
                        AppData.translate('Time Duration', 'مدة الوقوف'),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // منزلق الوقت (الذي سيتحكم في بداية التايمر)
                      _buildTimeSlider(),
                      
                      const SizedBox(height: 30),

                      // بطاقة معلومات السيارة والموقع (بيانات حقيقية)
                      _buildParkingInfoCard(),
                    ],
                  ),
                ),
              ),

              // البار السفلي للتحويل لصفحة الدفع أو التاريخ
              _buildBottomActionArea(),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت اختيار الوقت - التعديل الجوهري لربط التايمر
  Widget _buildTimeSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatTime(_currentValue), 
              style: const TextStyle(color: Color(0xFF195A64), fontWeight: FontWeight.bold)
            ),
            Text(AppData.translate('24 h', '٢٤ ساعة'), style: const TextStyle(color: Color(0xFF195A64))),
          ],
        ),
        Slider(
          value: _currentValue,
          min: 1.0, 
          max: 24.0,
          divisions: 23,
          activeColor: const Color(0xFF237D8C),
          inactiveColor: const Color(0xFFE5E5E5),
          onChanged: (value) {
            setState(() {
              _currentValue = value;
              // تحديث القيمة في AppData فوراً لكي يبدأ التايمر منها في الشاشات التالية
              AppData.durationHours = value.toInt(); 
            });
          },
        ),
      ],
    );
  }

  // بطاقة عرض البيانات المختارة فعلياً
  Widget _buildParkingInfoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F0F2).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE8ECEE)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                 // نوع السيارة واللوحة المختارة
                _buildRowInfo(
                  AppData.translate('VEHICLE TYPE', 'نوع المركبة'), 
                  AppData.translate(AppData.selectedVehicle, AppData.selectedVehicle == 'Sedan' ? 'سيدان' : 'مركبة'), 
                  'HZN | 8421' // هنا تظهر اللوحة (يمكنك جعلها متغيرة أيضاً)
                ),
                const SizedBox(height: 20),
                // الموقع المختار ورقم الموقف (Slot) من المخ
                _buildRowInfo(
                  AppData.translate('PARKING LOT', 'موقع الموقف'), 
                  AppData.selectedLocation, 
                  '${AppData.translate('Slot', 'موقف')} ${AppData.selectedSlot}'
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color(0xFFC3E6EC),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppData.translate('TOTAL', 'الإجمالي'), style: const TextStyle(color: Color(0xFF237D8C), fontWeight: FontWeight.bold)),
                Text(AppData.translate('FREE', 'مجاني'), style: const TextStyle(color: Color(0xFF237D8C), fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowInfo(String label, String val1, String val2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFA3237D8C), fontSize: 12, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(val1, style: const TextStyle(color: Color(0xFF192242), fontSize: 15, fontWeight: FontWeight.bold)),
            Text('• $val2', style: const TextStyle(color: Color(0xFF192242), fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomActionArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white, 
        boxShadow: [BoxShadow(blurRadius: 10, color: Color(0x12000000), offset: Offset(0, -2))]
      ),
      child: Row(
        children: [
          // زر الانتقال للتاريخ
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ParkingDetail2())),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Color(0xFFC3E6EC), shape: BoxShape.circle),
              child: const Icon(Icons.calendar_month_outlined, color: Color(0xFF237D8C)),
            ),
          ),
          const SizedBox(width: 15),
          // زر تأكيد الحجز والذهاب للدفع
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF237D8C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 0,
                ),
                child: Text(
                  AppData.translate('Confirm & Pay', 'تأكيد ودفع'), 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة تنسيق الوقت لتظهر باللغة المختارة وبالجمع الصحيح (ساعة/ساعات)
  String _formatTime(double value) {
    int hours = value.toInt();
    if (AppData.isArabic) {
      if (hours == 1) return 'ساعة واحدة';
      if (hours == 2) return 'ساعتين';
      if (hours >= 3 && hours <= 10) return '$hours ساعات';
      return '$hours ساعة';
    }
    return '$hours ${hours == 1 ? 'hour' : 'hours'}';
  }
}

// ويدجت الهيدر الموحد
class _ParkingHeader extends StatelessWidget {
  final String title;
  const _ParkingHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: AppData.isArabic ? null : 12,
            right: AppData.isArabic ? 12 : null,
            top: 22,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}