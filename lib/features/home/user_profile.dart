import 'package:flutter/material.dart';
import 'complain_screen.dart'; // استيراد صفحة الشكاوى الجديدة

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          // القسم العلوي (الهيدر)
          _buildHeader(),

          const SizedBox(height: 20),

          // معلومات المستخدم (الصورة والاسم)
          _buildProfileInfo(),

          const SizedBox(height: 30),

          // قائمة الخيارات
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.edit_outlined,
                  title: 'Edit Profile',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.directions_car_outlined,
                  title: 'My Vehicles',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: 'Complain',
                  onTap: () {
                    // الانتقال لصفحة الشكاوى
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ComplainScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.translate,
                  title: 'Language',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.report_problem_outlined,
                  title: 'My Violations',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.person_remove_outlined,
                  title: 'Delete Account',
                ),
                
                const SizedBox(height: 40),

                // زر تسجيل الخروج
                _buildLogoutButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة بناء الهيدر المتدرج
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
            'Profile',
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

  // دالة بناء معلومات المستخدم
  Widget _buildProfileInfo() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0x2666B0BD),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF237D8C), width: 1),
          ),
          child: const Center(
            child: Text(
              'A',
              style: TextStyle(
                fontSize: 32,
                color: Color(0xFF1A485F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'asaylfalh',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A485F),
          ),
        ),
      ],
    );}

  // دالة بناء عناصر القائمة بشكل موحد
  Widget _buildMenuItem(BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0x2666B0BD),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF1A485F), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1A485F),
            fontFamily: 'Inter',
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF1A485F),
        ),
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  // دالة بناء زر تسجيل الخروج
  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF69A2AC),
        minimumSize: const Size(double.infinity, 48),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: const Text(
        'Log out',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}