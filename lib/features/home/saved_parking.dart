import 'package:flutter/material.dart';

class SavedParking extends StatelessWidget {
  const SavedParking({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الهيدر العلوي
        Container(
          width: double.infinity,
          height: 100,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          child: const Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                'Saved',
                style: TextStyle(
                  color: Colors.white, // أبيض كما في الصورة
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        // قائمة الكروت المحفوظة
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              _buildSavedCard(
                'College of Science & Arts-Lot 2',
                'Spot No.A01',
              ),
              const SizedBox(height: 16),
              _buildSavedCard(
                'Warf Farm Parking -Area 2',
                'Spot No.B02',
              ),
              const SizedBox(height: 16),
              _buildSavedCard(
                'Jada Al-Nakheel Parking - Area 1',
                'Spot No.A04',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget مساعد لبناء الكارت مع النجمة
  Widget _buildSavedCard(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FCFD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF237D8C), width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF414141),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFB8B8B8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.star, // النجمة الزرقاء
            color: Color(0xFF237D8C),
            size: 24,
          ),
        ],
      ),
    );
  }
}