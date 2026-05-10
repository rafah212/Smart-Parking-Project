import 'package:parkliapp/core/services/local_session_service.dart';
import 'package:parkliapp/core/services/profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppUserSession {
  final String userId;
  final String authType;
  final String? email;
  final String? phoneNumber;

  const AppUserSession({
    required this.userId,
    required this.authType,
    this.email,
    this.phoneNumber,
  });
}

class AppSessionService {
  final LocalSessionService _localSessionService = LocalSessionService();
  final ProfileService _profileService = ProfileService();

  Future<AppUserSession?> getCurrentSession() async {
    final authType = await _localSessionService.getAuthType();

    if (authType == 'phone') {
      final phoneNumber = await _localSessionService.getPhoneNumber();

      if (phoneNumber == null || phoneNumber.trim().isEmpty) {
        return null;
      }

      final profile = await _profileService.getProfileByPhone(phoneNumber);

      if (profile == null) {
        return null;
      }

      final profileId = profile['id']?.toString();

      if (profileId == null || profileId.isEmpty) {
        return null;
      }

      return AppUserSession(
        userId: profileId,
        authType: 'phone',
        phoneNumber: phoneNumber,
      );
    }

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return null;
    }

    return AppUserSession(
      userId: user.id,
      authType: 'email',
      email: user.email,
    );
  }
}
