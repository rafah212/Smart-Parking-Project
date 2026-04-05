import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ لربط البيانات الحقيقية
import 'parking_timer.dart';

class ParkingTicket extends StatelessWidget {
  const ParkingTicket({super.key});

  void _goToTimer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParkingTimerPage()),
    );
  }

  // دالة لتنسيق التاريخ المختار ليظهر بشكل جميل
  String _getFormattedDate() {
    final date = AppData.selectedDate;
    List<String> monthsEn = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    List<String> monthsAr = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    
    String month = AppData.translate(monthsEn[date.month - 1], monthsAr[date.month - 1]);
    return "${date.day} $month ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold( // استبدلت ResponsivePreview بـ Scaffold لضمان التوافق
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
            ),
          ),
          child: Stack(
            children: [
              // زر الإغلاق
              Positioned(
                left: AppData.isArabic ? null : 20,
                right: AppData.isArabic ? 20 : null,
                top: 40,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => _goToTimer(context),
                ),
              ),

              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
                child: Column(
                  children: [
                    Text(
                      AppData.translate('Your Parking Ticket', 'تذكرة الموقف الخاصة بك'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 30),

                    // التذكرة الذكية
                    _buildTicketCard(),

                    const SizedBox(height: 30),

                    Text(
                      AppData.translate(
                        'Please scan the code on the parking when you arrived', 
                        'يرجى مسح الرمز الموجود عند الموقف عند وصولك'
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                    ),

                    const SizedBox(height: 40),

                    // أزرار التحكم
                    _buildActionButton(
                      context: context,
                      label: AppData.translate('Download', 'تحميل التذكرة'),
                      color: const Color(0xFF2B2C30),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppData.translate('Downloading PDF...', 'جاري تحميل الملف...'))),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    _buildActionButton(
                      context: context,
                      label: AppData.translate('Go to Timer', 'الذهاب للمؤقت'),
                      color: const Color(0xFF237D8C), 
                      onTap: () => _goToTimer(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(AppData.selectedLocation, // الموقع المختار فعلياً
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF192342), fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Unaizah 56453', style: TextStyle(color: Color(0xFF237D8C), fontSize: 14)),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: const Color(0xA3E2F7FB),
            child: Column(
              children: [
                _buildInfoRow(
                  AppData.translate('VEHICLE', 'المركبة'), 
                  AppData.translate(AppData.selectedVehicle, AppData.selectedVehicle == 'Sedan' ? 'سيدان' : 'مركبة'), 
                  'HZN | 8421'
                ),
                const SizedBox(height: 20),
                _buildInfoRow(
                  AppData.translate('DURATION', 'المدة'), 
                  '${AppData.durationHours} ${AppData.translate('hours', 'ساعات')}', 
                  _getFormattedDate() // التاريخ المختار من التقويم
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildHalfCircle(isLeft: true),
              Expanded(child: Container(height: 1, color: Colors.grey.withOpacity(0.3))),
              _buildHalfCircle(isLeft: false),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25),
            decoration: const BoxDecoration(color: Color(0x6BA1D5D9), borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
            child: Text(
              '${AppData.translate('Slot', 'موقف')} ${AppData.selectedSlot}', 
              textAlign: TextAlign.center, 
              style: const TextStyle(color: Color(0xFF192242), fontSize: 32, fontWeight: FontWeight.w900)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String val1, String val2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF237D8C), fontSize: 12, fontWeight: FontWeight.bold)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(val1, style: const TextStyle(color: Color(0xFF192242), fontSize: 16, fontWeight: FontWeight.bold)),
          Text('• $val2', style: const TextStyle(color: Color(0xFF192242), fontSize: 16, fontWeight: FontWeight.bold)),
        ]),
      ],
    );
  }

  Widget _buildHalfCircle({required bool isLeft}) {
    // تعديل اتجاه الدوائر بناءً على اللغة
    bool shouldReverse = AppData.isArabic;
    bool effectiveLeft = shouldReverse ? !isLeft : isLeft;

    return SizedBox(height: 30, width: 15, child: DecoratedBox(decoration: BoxDecoration(
      color: const Color(0xFF2992A3),
      borderRadius: BorderRadius.only(
        topRight: effectiveLeft ? const Radius.circular(30) : Radius.zero,
        bottomRight: effectiveLeft ? const Radius.circular(30) : Radius.zero,
        topLeft: effectiveLeft ? Radius.zero : const Radius.circular(30),
        bottomLeft: effectiveLeft ? Radius.zero : const Radius.circular(30),
      ),
    )));
  }

  Widget _buildActionButton({required BuildContext context, required String label, required Color color, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27.5)),
          elevation: 0,
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}