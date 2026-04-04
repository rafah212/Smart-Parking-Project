import 'package:flutter/material.dart';
import 'dart:io'; // للخروج من التطبيق

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  // القيمة الحالية المختارة (افتراضياً إنجليزي)
  String _selectedLanguage = 'English';

  // دالة إظهار التنبيه عند تغيير اللغة
  void _showLanguageConfirmation(String lang) {
    showDialog(
      context: context,
      barrierDismissible: false, // يمنع الإغلاق بالضغط خارج النافذة لضمان القرار
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Change Language',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'The app will close to apply the language change. It will work in the selected language the next time you open it. Do you want to proceed?',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF414141)),
              ),
              SizedBox(height: 10),
              Text(
                'سيتم إغلاق التطبيق لتطبيق تغيير اللغة، وسيعمل باللغة المختارة عند فتحه مرة أخرى. هل تريد المتابعة؟',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            // زر لا (إلغاء)
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedLanguage = 'English'; // إعادة الاختيار للوضع الأصلي إذا تراجع
                });
                Navigator.pop(context);
              },
              child: const Text(
                'No / لا',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
              ),
            ),
            // زر نعم (تأكيد)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF237D8C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              onPressed: () {
                exit(0); // إغلاق التطبيق
              },
              child: const Text(
                'Yes / نعم',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF414141), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Language',
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // خيار اللغة الإنجليزية
            _buildLanguageOption('English', 'English'),
            const Divider(height: 1, thickness: 0.5),
            // خيار اللغة العربية
            _buildLanguageOption('العربية', 'Arabic'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String title, String value) {
    return RadioListTile<String>(activeColor: const Color(0xFF237D8C),
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: Color(0xFF414141),
          fontWeight: FontWeight.w500,
        ),
      ),
      value: value,
      groupValue: _selectedLanguage,
      onChanged: (String? val) {
        if (val != null) {
          setState(() {
            _selectedLanguage = val;
          });
          _showLanguageConfirmation(val);
        }
      },
    );
  }
}