import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ لحفظ التاريخ

class ParkingDetail2 extends StatefulWidget {
  const ParkingDetail2({super.key});

  @override
  State<ParkingDetail2> createState() => _ParkingDetail2State();
}

class _ParkingDetail2State extends State<ParkingDetail2> {
  // الحصول على تاريخ اليوم الفعلي
  late DateTime _now;
  late int _daysInMonth;
  int? _selectedDay;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // حساب عدد الأيام في الشهر الحالي
    _daysInMonth = DateUtils.getDaysInMonth(_now.year, _now.month);
    _selectedDay = _now.day; // افتراضياً نحدد يوم اليوم
  }

  // دالة لجلب اسم الشهر الحالي بالعربي أو الإنجليزي
  String _getMonthName() {
    List<String> monthsEn = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    List<String> monthsAr = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    
    return AppData.translate(monthsEn[_now.month - 1], monthsAr[_now.month - 1]);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _ParkingHeader(title: AppData.translate('Parking detail', 'تفاصيل الموقف')),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        color: const Color(0xFFF3F3F3),
                        child: Center(
                          child: Image.asset(
                            'assets/images/parkdetial.png',
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // عرض الشهر الحالي والسنة تلقائياً
                            Text(
                              '${_getMonthName()} ${_now.year}',
                              style: const TextStyle(color: Color(0xFF192242), fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            _buildDaysOfWeek(),
                            const SizedBox(height: 10),
                            _buildCalendarGrid(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      // حفظ التاريخ المختار في AppData ليظهر في التيكت
                      if (_selectedDay != null) {
                        AppData.selectedDate = DateTime(_now.year, _now.month, _selectedDay!);
                      }
                      Navigator.pop(context); 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF237D8C),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    child: Text(
                      AppData.translate('Confirm Date', 'تأكيد التاريخ'),
                      style: const TextStyle(color: Colors.
                      white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    final days = AppData.isArabic 
        ? ['أح', 'اث', 'ثل', 'أر', 'خم', 'جم', 'سب']
        : ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) => Expanded(
        child: Center(
          child: Text(day, style: const TextStyle(color: Color(0xFF192242), fontWeight: FontWeight.w500)),
        ),
      )).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        int day = index + 1;
        bool isSelected = _selectedDay == day;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = day;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF237D8C) : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF192242),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ParkingHeader extends StatelessWidget {
  final String title;
  const _ParkingHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: AppData.isArabic ? null : 12,
            right: AppData.isArabic ? 12 : null,
            top: 25,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                AppData.isArabic ? Icons.arrow_forward : Icons.arrow_back, 
                color: Colors.white, size: 22
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}