import 'package:flutter/material.dart';

class ParkingDetail2 extends StatefulWidget {
  const ParkingDetail2({super.key});

  @override
  State<ParkingDetail2> createState() => _ParkingDetail2State();
}

class _ParkingDetail2State extends State<ParkingDetail2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. الهيدر الموحد (نفس نظام تطبيقكم) ---
            _ParkingHeader(title: 'Parking detail'),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // --- 2. خلفية الصورة (الجزء العلوي الرمادي) ---
                    Container(
                      width: double.infinity,
                      height: 250,
                      color: const Color(0xFFF3F3F3),
                      child: Center(
                        child: Image.asset(
                          'assets/images/parkdetial.png',
                          height: 200,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image, size: 80, color: Colors.grey),
                        ),
                      ),
                    ),

                    // --- 3. نافذة التقويم (التي تفتح من الأسفل في التصميم) ---
                    // هنا سنضع تصميم التقويم بشكل مرن
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCalendarHeader(),
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

            // --- 4. زر التأكيد السفلي ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // هنا ننتقل لصفحة الدفع مثلاً
                    Navigator.pop(context); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF237D8C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 4,
                    shadowColor: Colors.black45,
                  ),
                  child: const Text(
                    'Confirm Date',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // الجزء العلوي للتقويم (الشهر والأسهم)
  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'November 2025',
          style: TextStyle(color: Color(0xFF192242), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.keyboard_arrow_up, color: Color(0xFF192242))),
            IconButton(onPressed: () {}, icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF192242))),
          ],
        )
      ],
    );
  }

  // أيام الأسبوع
  Widget _buildDaysOfWeek() {
    final days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) => Expanded(
        child: Center(
        child: Text(day, style: const TextStyle(color: Color(0xFF192242), fontWeight: FontWeight.w500)),
        ),
      )).toList(),
    );
  }

  // شبكة الأيام (التقويم الفعلي)
  Widget _buildCalendarGrid() {
    // تمثيل بسيط للأيام كما في صورتك
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 31,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        int day = index + 1;
        bool isSelected = day == 25; // اليوم المختار في الصورة

        return Container(
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
        );
      },
    );
  }
}

// الهيدر الموحد لضمان التناسق
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
            left: 12,
            top: 15,
            bottom: 0,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            ),
          ),
          Center(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}