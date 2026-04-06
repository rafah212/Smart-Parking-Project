import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ
import 'package:url_launcher/url_launcher.dart'; // حزمة اختيارية لفتح الاتصال/الإيميل

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  // دالة اختيارية لفتح تطبيق الاتصال
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  // دالة اختيارية لفتح تطبيق الإيميل
  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
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
            icon: Icon(
              AppData.isArabic ? Icons.arrow_back_ios_new : Icons.arrow_back_ios_new, 
              color: const Color(0xFF414141), 
              size: 20
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppData.translate('Help & Support', 'الدعم والمساعدة'),
            style: const TextStyle(
              color: Color(0xFF2A2A2A),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppData.translate('Contact Information', 'معلومات التواصل'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF237D8C),
                ),
              ),
              const SizedBox(height: 25),
              
              // بطاقة رقم الهاتف
              GestureDetector(
                onTap: () => _makePhoneCall('0569225194'),
                child: _buildContactCard(
                  icon: Icons.phone_android_rounded,
                  title: AppData.translate('Phone Number', 'رقم الجوال'),
                  value: '0569225194',
                ),
              ),
              
              const SizedBox(height: 16),
              
              // بطاقة البريد الإلكتروني
              GestureDetector(
                onTap: () => _sendEmail('norah.n.mu@gmail.com'),
                child: _buildContactCard(
                  icon: Icons.email_outlined,
                  title: AppData.translate('Email Address', 'البريد الإلكتروني'),
                  value: 'norah.n.mu@gmail.com',
                ),
              ),
              
              const Spacer(),
              Center(
                child: Text(
                  AppData.translate('We are here to help you 24/7', 'نحن هنا لمساعدتك على مدار الساعة'),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({required IconData icon, required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FBFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF237D8C).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF237D8C), size: 24),
          ),
           const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF414141),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}