import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // نجعل الحالة الافتراضية تعتمد على الترجمة في المخ
  late String selectedTab;

  @override
  void initState() {
    super.initState();
    // نبدأ بتبويب المكتملة كافتراضي
    selectedTab = 'Completed';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildTabSwitcher(),
            const SizedBox(height: 20),
            Expanded(
              child: _buildBodyContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            AppData.translate('Booking', 'حجوزاتي'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFECF5F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF237D8C)),
      ),
      child: Row(
        children: [
          _buildTabItem('Upcoming', AppData.translate('Upcoming', 'القادمة')),
          _buildTabItem('Completed', AppData.translate('Completed', 'المكتملة')),
          _buildTabItem('Cancelled', AppData.translate('Cancelled', 'الملغاة')),
        ],
      ),
    );
  }

  Widget _buildTabItem(String key, String label) {
    bool isSelected = selectedTab == key;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = key;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF237D8C) : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF5A5A5A),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    if (selectedTab == 'Completed') {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          _buildBookingItem(
            AppData.translate('Hayit Harken Public Parking', 'مواقف هايت هاركن العامة'), 
            '${AppData.translate('Spot No.', 'رقم الموقف')} H04', 
            AppData.translate('Done', 'مكتمل'), 
            const Color(0xFF43A048)
          ),
          _buildBookingItem(
            AppData.translate('Al-Othaim-North Parking', 'مواقف العثيم - الشمال'), 
            '${AppData.translate('Spot No.', 'رقم الموقف')} N33', 
            AppData.translate('Done', 'مكتمل'), 
            const Color(0xFF43A048)
          ),
        ],
      );
    } else if (selectedTab == 'Upcoming') {
      return Center(
        child: Text(
          AppData.translate('No upcoming bookings found', 'لا توجد حجوزات قادمة حالياً'),
          style: const TextStyle(color: Colors.grey)
        ),
      );
    } else {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          _buildBookingItem(
            AppData.translate('King Saud Hospital', 'مستشفى الملك سعود'), 
            '${AppData.translate('Spot No.', 'رقم الموقف')} V15', 
            AppData.translate('Cancelled', 'ملغى'), 
            Colors.red
          ),
        ],
      );
    }
  }

  Widget _buildBookingItem(String title, String spot, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF237D8C), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF414141))),
                const SizedBox(height: 4),
                Text(spot, style: const TextStyle(fontSize: 12, color: Color(0xFFB8B8B8))),
              ],
            ),
          ),
          Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}