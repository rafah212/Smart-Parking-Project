import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  Future<void> createUserProfile({
    required User user,
    required String fullName,
    required String phoneNumber,
    required String email,
  }) async {
    await _supabase.from('users').upsert({
      'uid': user.id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final data = await _supabase
        .from('users')
        .select()
        .eq('uid', uid)
        .maybeSingle();

    return data;
  }
}