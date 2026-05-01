import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:parkliapp/core/services/local_session_service.dart';
import 'complain_screen.dart';
import 'help_support_screen.dart';
import 'language_screen.dart';
import 'edit_profile_screen.dart';
import 'my_vehicles_screen.dart';
import 'my_violations_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ProfileService _profileService = ProfileService();

  UserProfileData? _profile;
  bool _isLoading = true;
  String? _error;
  String? _localUpdatedName;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        final profile = await _profileService.getCurrentUserProfile(user.id);

        if (!mounted) return;
        setState(() {
          _profile = profile;
          _isLoading = false;
          _error = null;
        });
        return;
      }

      final localSession = LocalSessionService();
      final phoneNumber = await localSession.getPhoneNumber();

      if (phoneNumber == null || phoneNumber.trim().isEmpty) {
        if (!mounted) return;
        setState(() {
          _error = AppData.translate(
            'You need to log in first',
            'يجب تسجيل الدخول أولاً',
          );
          _isLoading = false;
        });
        return;
      }

      final profileMap = await _profileService.getProfileByPhone(phoneNumber);

      if (!mounted) return;

      if (profileMap == null) {
        setState(() {
          _error = AppData.translate(
            'Profile data not found',
            'لم يتم العثور على بيانات الملف الشخصي',
          );
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _profile = UserProfileData.fromMap(profileMap);
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppData.translate(
          'Failed to load profile',
          'فشل تحميل الملف الشخصي',
        );
        _isLoading = false;
      });
    }
  }

  String get _displayName {
    if ((_localUpdatedName ?? '').trim().isNotEmpty) {
      return _localUpdatedName!.trim();
    }

    final fullName = _profile?.fullName.trim() ?? '';
    if (fullName.isNotEmpty) return fullName;

    return Supabase.instance.client.auth.currentUser?.email ?? 'User';
  }

  String get _displayInitial {
    final name = _displayName.trim();
    if (name.isEmpty) return 'U';
    return name.characters.first.toUpperCase();
  }

  Future<void> _logout() async {
    await _profileService.signOut();
    await LocalSessionService().clearSession();

    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/loginEmail',
      (route) => false,
    );
  }

  Future<void> _refreshProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final profile = await _profileService.getCurrentUserProfile(user.id);

    if (!mounted) return;
    setState(() {
      _profile = profile;
    });
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              AppData.translate('Delete Account', 'حذف الحساب'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              AppData.translate(
                'Are you sure you want to delete your account? This action cannot be undone.',
                'هل أنت متأكد من حذف الحساب؟ لا يمكنك التراجع عن هذا الإجراء لاحقاً.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppData.translate('Cancel', 'إلغاء'),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppData.translate(
                          'Account deletion request sent',
                          'تم إرسال طلب حذف الحساب',
                        ),
                      ),
                    ),
                  );
                },
                child: Text(
                  AppData.translate('Delete', 'حذف'),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection:
              AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              AppData.translate('Logout', 'تسجيل الخروج'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              AppData.translate(
                'Are you sure you want to log out?',
                'هل أنت متأكد أنك تريد تسجيل الخروج؟',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  AppData.translate('Stay', 'بقاء'),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await _logout();
                },
                child: Text(
                  AppData.translate('Logout', 'خروج'),
                  style: const TextStyle(
                    color: Color(0xFF195A64),
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
        backgroundColor: const Color(0xFFF4F4F4),
        body: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 60),
                child: CircularProgressIndicator(),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else ...[
              _buildProfileInfo(),
              const SizedBox(height: 30),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshProfile,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.edit_outlined,
                        title: AppData.translate(
                          'Edit Profile',
                          'تعديل الملف الشخصي',
                        ),
                        onTap: () async {
                          final String? updatedName = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );

                          if (updatedName != null &&
                              updatedName.trim().isNotEmpty) {
                            setState(() {
                              _localUpdatedName = updatedName.trim();
                            });
                          }

                          await _refreshProfile();
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.directions_car_outlined,
                        title: AppData.translate('My Vehicles', 'مركباتي'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyVehiclesScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.chat_bubble_outline,
                        title: AppData.translate('Complain', 'تقديم بلاغ'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ComplainScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.translate,
                        title: AppData.translate('Language', 'اللغة'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LanguageScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.report_problem_outlined,
                        title: AppData.translate('My Violations', 'مخالفاتي'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyViolationsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.help_outline,
                        title: AppData.translate(
                          'Help & Support',
                          'الدعم والمساعدة',
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSupportScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.person_remove_outlined,
                        title:
                            AppData.translate('Delete Account', 'حذف الحساب'),
                        onTap: () => _showDeleteAccountDialog(context),
                      ),
                      const SizedBox(height: 40),
                      _buildLogoutButton(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
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
            AppData.translate('Profile', 'الملف الشخصي'),
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

  Widget _buildProfileInfo() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0x2666B0BD),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF237D8C),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              _displayInitial,
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
          _displayName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A485F),
          ),
        ),
        if ((_profile?.email ?? '').isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            _profile!.email,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF7A8A90),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
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
          child: Icon(
            icon,
            color: const Color(0xFF1A485F),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1A485F),
          ),
        ),
        trailing: Icon(
          AppData.isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
          size: 16,
          color: const Color(0xFF1A485F),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Text(
        AppData.translate('Log out', 'تسجيل الخروج'),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
