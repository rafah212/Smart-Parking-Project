import 'package:flutter/material.dart';

class MyViolationsScreen extends StatelessWidget {
  const MyViolationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // زر الرجوع للخلف
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF414141), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Violations',
          style: TextStyle(
            color: Color(0xFF2A2A2A),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة توضيحية تعبر عن المخالفات (سيارة مع علامة تحذير)
            Center(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.directions_car_filled_rounded, size: 80, color: Color(0xFF237D8C).withOpacity(0.2)),
                    const Icon(Icons.assignment_late_rounded, size: 60, color: Color(0xFF237D8C)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // العنوان الرئيسي
            const Text(
              'Easily view your violations',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A485F),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 15),
            
            // الوصف
            const Text(
              'Verify your account through the Nafath service to get direct access to your registered violation details.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF898989),
                height: 1.5,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 50),
            
            // زر توثيق الحساب
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => _showNafathSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF237D8C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text(
                  'Verify Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // نافذة نفاذ السوداء (تظهر عند النقر على الزر)
  void _showNafathSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20, left: 20, right: 20
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF0F0F0F), // لون نفاذ الداكن
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const SizedBox(height: 10),
            const Text(
              'نفاذ',
              style: TextStyle(color: Color(0xFF237D8C), fontSize: 45, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Verification via Nafath App\nPlease enter your National ID',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 30),
            TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter National ID',
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF237D8C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Next', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}