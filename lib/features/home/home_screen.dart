import 'package:flutter/material.dart';
import 'widgets/home_bottom_nav.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/map_section.dart';
import 'widgets/visited_parks_section.dart';
import 'saved_parking.dart'; // استيراد ملف صفحة السيف الجديد

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // هذا المتغير يحدد أي صفحة نعرض الآن (0 للهوم، 1 للسيف)
  int _currentIndex = 0;

  // دالة لبناء محتوى صفحة الهوم (الخريطة والبحث)
  Widget _buildHomeBody() {
    return Column(
      children: [
        const HomeHeader(),
        const MapSection(),
        Expanded(
          child: Transform.translate(
            offset: const Offset(0, -18),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: const SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          Expanded(child: HomeSearchBar()),
                          SizedBox(width: 10),
                          _FilterButton(),
                        ],
                      ),
                    ),
                    SizedBox(height: 18),
                    VisitedParksSection(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // قائمة الصفحات المتاحة للتنقل
    final List<Widget> pages = [
      _buildHomeBody(),      // الصفحة رقم 0
      const SavedParking(),  // الصفحة رقم 1
      const Center(child: Text('Booking')), // الصفحة رقم 2 (مؤقتة)
      const Center(child: Text('Profile')), // الصفحة رقم 3 (مؤقتة)
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      // نمرر الـ currentIndex والوظيفة للشريط السفلي
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // تحديث الصفحة عند الضغط
          });
        },
      ),
      body: SafeArea(
        // عرض الصفحة المختارة بناءً على الـ index
        child: pages[_currentIndex],
      ),
    );
  }
}

// زر الفلتر يبقى كما هو
class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFF5FBFC),
        border: Border.all(color: const Color(0x30777777)),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Icon(Icons.tune_rounded, color: Color(0xFF237D8C), size: 22),
    );
  }
}