import 'package:flutter/material.dart';
import 'parking_detail2.dart';

class ParkingDetail1 extends StatefulWidget {
  const ParkingDetail1({super.key});

  @override
  State<ParkingDetail1> createState() => _ParkingDetail1State();
}

class _ParkingDetail1State extends State<ParkingDetail1> {
  // متغير الوقت التفاعلي (يبدأ من ساعة واحدة)
  double _currentValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. الهيدر ---
            _ParkingHeader(title: 'Parking detail'),

            // --- 2. محتوى الصفحة القابل للتمرير ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الصورة اللي اضفتها
                    Center(
                      child: Image.asset(
                        'assets/images/parkdetial.png',
                        height: 220,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // عنوان الوقت
                    const Text(
                      'Time Duration',
                      style: TextStyle(
                        color: Color(0xFF237D8C),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // منزلق الوقت التفاعلي (من 15 دقيقة لـ 24 ساعة)
                    _buildTimeSlider(),
                    
                    const SizedBox(height: 30),

                    // بطاقة تفاصيل السيارة والموقف
                    _buildParkingInfoCard(),
                  ],
                ),
              ),
            ),

            // --- 3. البار السفلي (Confirm & Pay) ---
            _buildBottomActionArea(),
          ],
        ),
      ),
    );
  }

  // ويدجت شريط الوقت
  Widget _buildTimeSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatTime(_currentValue), style: const TextStyle(color: Color(0xFF195A64), fontWeight: FontWeight.bold)),
            const Text('24 h', style: TextStyle(color: Color(0xFF195A64))),
          ],
        ),
        Slider(
          value: _currentValue,
          min: 0.25, // 15 دقيقة
          max: 24.0,
          divisions: 95,
          activeColor: const Color(0xFF237D8C),
          inactiveColor: const Color(0xFFE5E5E5),
          onChanged: (value) => setState(() => _currentValue = value),
        ),
      ],
    );
  }

  // بطاقة البيانات (CAR & SLOT)
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
                _buildRowInfo('VEHICLE TYPE', 'CAR', 'HZN | 8421'),
                const SizedBox(height: 20),
                _buildRowInfo('PARKING LOT', 'College of Science & Art', 'Slot A5'),
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
              children: const [
                Text('TOTAL', style: TextStyle(color: Color(0xFF237D8C), fontWeight: FontWeight.bold)),
                Text('FREE', style: TextStyle(color: Color(0xFF237D8C), fontSize: 18, fontWeight: FontWeight.bold)),
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

  // منطقة الأزرار السفلية
  Widget _buildBottomActionArea() {
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
    decoration: const BoxDecoration(
      color: Colors.white, 
      boxShadow: [BoxShadow(blurRadius: 10, color: Color(0x12000000), offset: Offset(0, -2))]
    ),
    child: Row(
      children: [
        // --- تعديل أيقونة التاريخ هنا ---
        InkWell(
          onTap: () {
            // هذا الكود يفتح صفحة التقويم 
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ParkingDetail2()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFC3E6EC), 
              shape: BoxShape.circle
            ),
            child: const Icon(Icons.calendar_month_outlined, color: Color(0xFF237D8C)),
          ),
        ),
        
        const SizedBox(width: 15),
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                // هنا  نربط بصفحة "تم الدفع بنجاح"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF237D8C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 0,
              ),
              child: const Text(
                'Confirm & Pay', 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  String _formatTime(double value) {
    int hours = value.toInt();
    int minutes = ((value - hours) * 60).round();
    if (hours == 0) return '$minutes min';
    return minutes == 0 ? '$hours h' : '$hours h $minutes min';
  }
}

// ---ويدجت الهيدر لنفس التطبيق ---
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
            left: 12,
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