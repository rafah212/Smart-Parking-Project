import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // المتغير الذي يحدد الحالة المختارة حالياً
  String selectedTab = 'Completed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          
          // شريط التبديل التفاعلي
          _buildTabSwitcher(),
          
          const SizedBox(height: 20),
          
          // عرض المحتوى بناءً على التبويب المختار
          Expanded(
            child: _buildBodyContent(),
          ),
        ],
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
      child: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'Booking',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Poppins',
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
          _buildTabItem('Upcoming'),
          _buildTabItem('Completed'),
          _buildTabItem('Cancelled'),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label) {
    bool isSelected = selectedTab == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = label; // تحديث التبويب المختار عند النقر
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
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // دالة لعرض محتوى مختلف لكل حالة
  Widget _buildBodyContent() {
    if (selectedTab == 'Completed') {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          _buildBookingItem('Hayit Harken Public Parking-Area 1', 'Spot No.H04', 'Done', Color(0xFF43A048)),
          _buildBookingItem('Al-Othaim-North Parking', 'Spot No.N33', 'Done', Color(0xFF43A048)),
          _buildBookingItem('College of Medicine-Staff Parking', 'Spot No.M02', 'Done', Color(0xFF43A048)),
        ],
      );
    } else if (selectedTab == 'Upcoming') {
      return const Center(
        child: Text('No upcoming bookings found', style: TextStyle(color: Colors.grey)),
      );
    } else {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          _buildBookingItem('King Saud Hospital', 'Spot No.V15', 'Cancelled', Colors.red),
        ],
      );
    }
  }

  Widget _buildBookingItem(String title, String spot, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,borderRadius: BorderRadius.circular(8),
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