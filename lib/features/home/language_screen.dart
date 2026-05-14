import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; 
import 'home_screen.dart'; // استيراد الرئيسية  

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  
  // دالة  نافذة التأكيد وتغيير اللغة
  void _showLanguageDialog(String languageCode) {
    // تحديد النصوص  حسب اللغة اللي اختارها المستخدم 
    bool isArabicChoice = languageCode == 'ar';
    String title = isArabicChoice ? 'تغيير اللغة' : 'Change Language';
    String message = isArabicChoice 
        ? 'هل أنت متأكد أنك تريد تغيير اللغة إلى العربية؟' 
        : 'Are you sure you want to change the language to English?';
    String yesBtn = isArabicChoice ? 'نعم' : 'Yes';
    String noBtn = isArabicChoice ? 'لا' : 'No';

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          //  اتجاه النافذة يتبع الخيار الجديد ليعرف المستخدم كيف ستكون الواجهة
          textDirection: isArabicChoice ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: [
              // زر "لا" - لا يغير شيئاً
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(noBtn, style: const TextStyle(color: Colors.grey)),
              ),
              // زر "نعم" - هو الذي يغير اللغة ويحول للرئيسية
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    AppData.isArabic = (languageCode == 'ar'); // تحديث اللغة  
                  });
                  
                  // العودة للرئيسية وتصفير الـ Stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF237D8C),
                  foregroundColor: Colors.white,
                ),
                child: Text(yesBtn),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF414141), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppData.translate('Language', 'اللغة'),
            style: const TextStyle(color: Color(0xFF2A2A2A), fontSize: 18, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppData.translate('Select your preferred language', 'اختر لغتك المفضلة'),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 25),
              
              // خيار اللغة العربية
              _buildLanguageOption(
                title: 'العربية',
                isSelected: AppData.isArabic,
                onTap: () => _showLanguageDialog('ar'),
              ),
              
              const SizedBox(height: 15),
              
              // خيار اللغة الإنجليزية
              _buildLanguageOption(
                title: 'English',
                isSelected: !AppData.isArabic,
                onTap: () => _showLanguageDialog('en'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({required String title, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5FBFC) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF237D8C) : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF237D8C) : const Color(0xFF414141),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF237D8C)),
          ],
        ),
      ),
    );
  }
}