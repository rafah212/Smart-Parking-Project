import 'package:flutter/material.dart';
import 'package:parkliapp/core/services/profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'complain_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      setState(() {
        _error = 'You need to log in first';
        _isLoading = false;
      });
      return;
    }

    try {
      final profile = await _profileService.getCurrentUserProfile(user.id);

      if (!mounted) return;
      setState(() {
        _profile = profile;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String get _displayName {
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

    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  _buildLogoutButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
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
            fontFamily: 'Poppins',
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

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: _logout,
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