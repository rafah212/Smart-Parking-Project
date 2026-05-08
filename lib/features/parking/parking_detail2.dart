import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:parkliapp/app_data.dart';
import 'package:intl/intl.dart';

import 'dart:ui' as ui; 

class ParkingDetail2 extends StatefulWidget {
  const ParkingDetail2({super.key});

  @override
  State<ParkingDetail2> createState() => _ParkingDetail2State();
}

class _ParkingDetail2State extends State<ParkingDetail2> {
  late DateTime _now;
  late int _daysInMonth;
  int? _selectedDay;
  
  // الوقت الافتراضي
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _daysInMonth = DateUtils.getDaysInMonth(_now.year, _now.month);
    _selectedDay = _now.day;
  }

  String _getMonthName() {
    List<String> monthsEn = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    List<String> monthsAr = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    return AppData.translate(monthsEn[_now.month - 1], monthsAr[_now.month - 1]);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // تم التعديل هنا لإنهاء الخط الأحمر: استخدمنا ui.TextDirection
      textDirection: AppData.isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _ParkingHeader(title: AppData.translate('Parking detail', 'تفاصيل الموقف')),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 180,
                        color: const Color(0xFFF3F3F3),
                        child: Center(
                          child: Image.asset(
                            'assets/images/parkdetial.png',
                            height: 140,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_getMonthName()} ${_now.year}',
                              style: const TextStyle(color: Color(0xFF192242), fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            _buildDaysOfWeek(),
                            const SizedBox(height: 10),
                            _buildCalendarGrid(),
                            const SizedBox(height: 30),
                            Text(
                              AppData.translate('Select Time', 'اختر الوقت'),
                              style: const TextStyle(color: Color(0xFF192242), fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            
                            // الـ Wheel Picker
                            _buildTimeWheelPicker(),
                            
                            const SizedBox(height: 20),
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
                    onPressed: (_selectedDay != null)
                   ? () {
                          // 1. دمج التاريخ المختار مع الوقت المختار من الـ Wheel Picker
                          final DateTime fullDateTime = DateTime(
                            _now.year,
                            _now.month,
                            _selectedDay!,
                            _selectedDateTime.hour,
                            _selectedDateTime.minute,
                          );

                          // 2. تخزين القيمة الأساسية للتايمر
                          AppData.bookingStartTime = fullDateTime;
                          AppData.bookingEndTime = fullDateTime.add(Duration(hours: AppData.durationHours));
                          // 3. تحديث القيم النصية (إذا كنتِ تستخدمينها للعرض فقط)
                          AppData.selectedDate = fullDateTime;
                          AppData.selectedTime = DateFormat('hh:mm a').format(_selectedDateTime);
                          
                          Navigator.pop(context); 
                        }
                      : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF237D8C),
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    child: Text(
                      AppData.translate('Confirm Date & Time', 'تأكيد التاريخ والوقت'),
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildTimeWheelPicker() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        initialDateTime: _selectedDateTime,
        use24hFormat: false,
        onDateTimeChanged: (DateTime newTime) {
          setState(() {
            _selectedDateTime = newTime;
          });
        },
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
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        int day = index + 1;
        bool isPast = day < _now.day;
        bool isSelected = _selectedDay == day;

        return GestureDetector(
          onTap: isPast ? null : () => setState(() => _selectedDay = day),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF237D8C) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isSelected ? null : Border.all(color: Colors.grey[200]!),
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: isPast 
                      ? Colors.grey[300] 
                      : (isSelected ? Colors.white : const Color(0xFF192242)),
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
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}