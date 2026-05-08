import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class UserProfileData {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? avatarUrl; 

  const UserProfileData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.avatarUrl, 
  });

  factory UserProfileData.fromMap(Map<String, dynamic> map) {
    return UserProfileData(
      id: map['id']?.toString() ?? '',
      fullName: map['full_name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phoneNumber: map['phone_number']?.toString() ?? '',
      // تم تعديل المفتاح هنا ليطابق قاعدة بياناتك (avatars_url)
      avatarUrl: map['avatars_url']?.toString(), 
    );
  }
}

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;
  final Uuid _uuid = const Uuid();

  Future<Map<String, dynamic>?> getProfileByPhone(String phoneNumber) async {
    final normalizedPhone = _normalizePhone(phoneNumber);

    final result = await _client
        .from('profiles')
        .select()
        .eq('phone_number', normalizedPhone)
        .maybeSingle();

    return result;
  }

  Future<Map<String, dynamic>?> getProfileByEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();

    final result = await _client
        .from('profiles')
        .select()
        .eq('email', normalizedEmail)
        .maybeSingle();

    return result;
  }

  Future<bool> hasProfileByPhone(String phoneNumber) async {
    final profile = await getProfileByPhone(phoneNumber);
    return profile != null;
  }

  Future<bool> hasProfileByEmail(String email) async {
    final profile = await getProfileByEmail(email);
    return profile != null;
  }

  Future<UserProfileData?> getCurrentUserProfile(String userId) async {
    final result = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (result == null) return null;
    return UserProfileData.fromMap(result);
  }

  Future<void> upsertProfile({
    required String userId,
    required String fullName,
    required String email,
    required String phoneNumber,
    String? avatarUrl, 
  }) async {
    final data = {
      'id': userId,
      'full_name': fullName.trim(),
      'email': email.trim().toLowerCase(),
      'phone_number': _normalizePhone(phoneNumber),
    };

    // تم تعديل المفتاح هنا ليطابق قاعدة بياناتك (avatars_url)
    if (avatarUrl != null) {
      data['avatars_url'] = avatarUrl;
    }

    await _client.from('profiles').upsert(data);
  }

  Future<void> upsertPhoneProfile({
    required String fullName,
    required String phoneNumber,
    String email = '',
  }) async {
    final normalizedPhone = _normalizePhone(phoneNumber);
    final normalizedEmail = email.trim().toLowerCase();

    final existing = await getProfileByPhone(normalizedPhone);
    final id = existing?['id']?.toString() ?? _uuid.v4();

    await _client.from('profiles').upsert({
      'id': id,
      'full_name': fullName.trim(),
      'email': normalizedEmail,
      'phone_number': normalizedPhone,
    });
  }

  Future<void> upsertEmailProfile({
    required String userId,
    required String fullName,
    required String email,
    String phoneNumber = '',
  }) async {
    await _client.from('profiles').upsert({
      'id': userId,
      'full_name': fullName.trim(),
      'email': email.trim().toLowerCase(),
      'phone_number': phoneNumber.trim(),
    });
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  String _normalizePhone(String phoneNumber) {
    String phone = phoneNumber.trim().replaceAll(RegExp(r'[^0-9+]'), '');

    if (phone.startsWith('00')) {
      phone = '+${phone.substring(2)}';
    }

    if (phone.startsWith('966')) {
      phone = '+$phone';
    }

    return phone;
  }
}