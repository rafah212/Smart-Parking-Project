import 'package:flutter/material.dart';

// استيراد الشاشات المرتبطة
import 'complain_screen.dart';
import 'help_support_screen.dart';
import 'language_screen.dart';
import 'edit_profile_screen.dart';
import 'my_vehicles_screen.dart'; 
import 'my_violations_screen.dart'; 

// المتغير العام لحفظ الاسم
String globalUserName = 'asaylfalh'; 

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          // 1. الهيدر العلوي (التصميم المتدرج)
          _buildHeader(),

          const SizedBox(height: 20),

          // 2. معلومات المستخدم (الصورة والاسم)
          _buildProfileInfo(),

          const SizedBox(height: 30),

          // 3. قائمة الخيارات
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // تعديل الملف الشخصي
                _buildMenuItem(
                  context,
                  icon: Icons.edit_outlined,
                  title: 'Edit Profile',
                  onTap: () async {
                    final String? updatedName = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    );

                    if (updatedName != null && updatedName.isNotEmpty) {
                      setState(() {
                        globalUserName = updatedName;
                      });
                    }
                  },
                ),

                // شاشة مركباتي
                _buildMenuItem(
                  context,
                  icon: Icons.directions_car_outlined,
                  title: 'My Vehicles',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyVehiclesScreen()),
                    );
                  },
                ),

                // الشكاوى
                _buildMenuItem(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: 'Complain',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ComplainScreen()),
                    );
                  },
                ),

                // اللغة
                _buildMenuItem(
                  context,
                  icon: Icons.translate,
                  title: 'Language',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LanguageScreen()),
                    );
                  },
                ),

                // شاشة المخالفات
                _buildMenuItem(
                  context, 
                  icon: Icons.report_problem_outlined, 
                  title: 'My Violations',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyViolationsScreen()),
                    );
                  },
                ),

                // الدعم الفني
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                    );
                  },
                ),

                // حذف الحساب مع نافذة تأكيد
                _buildMenuItem(
                  context, 
                  icon: Icons.person_remove_outlined, 
                  title: 'Delete Account',
                  onTap: () => _showDeleteAccountDialog(context),
                ),
                
                const SizedBox(height: 40),

                // زر تسجيل الخروج مع نافذة تأكيد
                _buildLogoutButton(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- دالة إظهار نافذة تأكيد حذف الحساب ---
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Delete Account', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deletion request sent')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // --- دالة إظهار نافذة تأكيد تسجيل الخروج ---
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Logout', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Stay', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // هنا يتم وضع كود العودة لصفحة LoginScreen مستقبلاً
              },
              child: const Text('Logout', style: TextStyle(color: Color(0xFF195A64), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // --- دالة بناء الهيدر ---
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

  // --- دالة عرض معلومات المستخدم ---
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
          child: Center(
            child: Text(
              globalUserName.isNotEmpty ? globalUserName[0].toUpperCase() : 'A',
              style: const TextStyle(
                fontSize: 32,
                color: Color(0xFF1A485F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          globalUserName,style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A485F),
          ),
        ),
      ],
    );
  }

  // --- دالة بناء عناصر القائمة ---
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
      ),
    );
  }

  // --- زر تسجيل الخروج ---
  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showLogoutDialog(context),
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
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}