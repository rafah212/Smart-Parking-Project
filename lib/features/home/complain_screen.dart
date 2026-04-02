import 'package:flutter/material.dart';

class ComplainScreen extends StatefulWidget {
  const ComplainScreen({super.key});

  @override
  State<ComplainScreen> createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  // المتغير الذي سيحمل القيمة المختارة من القائمة
  String selectedValue = 'Parking is not available';

  // قائمة الخيارات
  final List<String> complainOptions = [
    'Parking is not available',
    'Another',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF414141), size: 20),
          onPressed: () => Navigator.pop(context),
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
            // القائمة المنسدلة (Dropdown)
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
                      setState(() {
                        selectedValue = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // صندوق إدخال النص
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
            // زر الإرسال
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Complain Submitted successfully!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF237D8C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('Submit',
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