import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

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
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        body: Column(
          children: [
            // 1. الهيدر العلوي
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
                    title: AppData.translate('Edit Profile', 'تعديل الملف الشخصي'),
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
                    title: AppData.translate('My Vehicles', 'مركباتي'),
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
                    title: AppData.translate('Complain', 'تقديم بلاغ'),
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
                    title: AppData.translate('Language', 'اللغة'),
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
                    title: AppData.translate('My Violations', 'مخالفاتي'),
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
                    title: AppData.translate('Help & Support', 'الدعم والمساعدة'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                      );
                    },
                  ),

                  // حذف الحساب
                  _buildMenuItem(
                    context, 
                    icon: Icons.person_remove_outlined, 
                    title: AppData.translate('Delete Account', 'حذف الحساب'),
                    onTap: () => _showDeleteAccountDialog(context),
                  ),
                  
                  const SizedBox(height: 40),

                  // زر تسجيل الخروج
                  _buildLogoutButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- نافذة تأكيد حذف الحساب ---
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(AppData.translate('Delete Account', 'حذف الحساب'), style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Text(AppData.translate(
              'Are you sure you want to delete your account? This action cannot be undone.',
              'هل أنت متأكد من حذف الحساب؟ لا يمكنك التراجع عن هذا الإجراء لاحقاً.'
            )),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppData.translate('Cancel', 'إلغاء'), style: const TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppData.translate('Account deletion request sent', 'تم إرسال طلب حذف الحساب'))),
                  );
                },
                child: Text(AppData.translate('Delete', 'حذف'), style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- نافذة تأكيد تسجيل الخروج ---
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(AppData.translate('Logout', 'تسجيل الخروج'), style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Text(AppData.translate('Are you sure you want to log out?', 'هل أنت متأكد أنك تريد تسجيل الخروج؟')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppData.translate('Stay', 'بقاء'), style: const TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // العودة لصفحة الدخول مستقبلاً
                },
                child: Text(AppData.translate('Logout', 'خروج'), style: const TextStyle(color: Color(0xFF195A64), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF195A64), Color(0xFF34B5CA)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            AppData.translate('Profile', 'الملف الشخصي'),
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: const Color(0x2666B0BD),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF237D8C), width: 1),
          ),
          child: Center(
            child: Text(
              globalUserName.isNotEmpty ? globalUserName[0].toUpperCase() : 'A',
              style: const TextStyle(fontSize: 32, color: Color(0xFF1A485F), fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          globalUserName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF1A485F)),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Color(0x2666B0BD), shape: BoxShape.circle),
          child: Icon(icon, color: const Color(0xFF1A485F), size: 20),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16, color: Color(0xFF1A485F))),
        trailing: Icon(
          AppData.isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
          size: 16, color: const Color(0xFF1A485F),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showLogoutDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF69A2AC),
        minimumSize: const Size(double.infinity, 48),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      child: Text(
        AppData.translate('Log out', 'تسجيل الخروج'),
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}