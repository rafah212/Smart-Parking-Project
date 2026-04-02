import 'package:flutter/material.dart';
import 'home_screen.dart'; // تأكد أن هذا هو المسار الصحيح لملف الهوم سكرين

class ComplainScreen extends StatefulWidget {
  const ComplainScreen({super.key});

  @override
  State<ComplainScreen> createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  String selectedValue = 'Parking is not available';
  final List<String> complainOptions = [
    'Parking is not available',
    'Another',
  ];

  // دالة إظهار نافذة النجاح المنبثقة
  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false, // يمنع الإغلاق عند الضغط خارج النافذة
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // زر الإغلاق (X) في الزاوية
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF5A5A5A), size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // أيقونة الصح الأخضر
                const Icon(
                  Icons.check_circle_rounded,
                  size: 80,
                  color: Color(0xFF43A048),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Send successful',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2A2A2A),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your complain has been send successful',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    color: Color(0xFF898989),
                  ),
                ),
                const SizedBox(height: 25),
                // زر العودة للهوم (ينظف الـ Stack ويرجعك للبداية)
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      // الكود الذي يضمن العودة لصفحة الهوم مباشرة وتصفير التنقل
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF237D8C),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Back Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF414141), size: 20),onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Complain',
          style: TextStyle(
            color: Color(0xFF2A2A2A),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            // القائمة المنسدلة
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFB8B8B8)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedValue,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF414141)),
                  isExpanded: true,
                  style: const TextStyle(
                    color: Color(0xFF414141),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                  items: complainOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => selectedValue = newValue);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // صندوق إدخال الشكوى
            Container(
              width: double.infinity,
              height: 150,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFB8B8B8)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Write your complain here (minimum 10 characters)',
                  hintStyle: TextStyle(color: Color(0xFFD0D0D0), fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // زر Submit
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _showSuccessPopup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF237D8C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}