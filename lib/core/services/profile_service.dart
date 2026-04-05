import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileData {
  final String fullName;
  final String email;
  final String phoneNumber;

  const UserProfileData({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      fullName: (json['full_name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phoneNumber: (json['phone_number'] ?? '') as String,
    );
  }
}

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserProfileData?> getCurrentUserProfile(String userId) async {
    final data = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (data == null) return null;
    return UserProfileData.fromJson(data);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}