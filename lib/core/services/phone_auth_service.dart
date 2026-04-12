import 'package:supabase_flutter/supabase_flutter.dart';

class PhoneAuthService {
  final GoTrueClient _auth = Supabase.instance.client.auth;

  Future<void> sendOtp({
    required String phoneNumber,
    bool shouldCreateUser = true,
  }) async {
    await _auth.signInWithOtp(
      phone: phoneNumber,
      shouldCreateUser: shouldCreateUser,
    );
  }

  Future<AuthResponse> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    return await _auth.verifyOTP(
      type: OtpType.sms,
      phone: phoneNumber,
      token: code,
    );
  }

  User? get currentUser => _auth.currentUser;

  Session? get currentSession => _auth.currentSession;

  Future<void> signOut() async {
    await _auth.signOut();
  }
}