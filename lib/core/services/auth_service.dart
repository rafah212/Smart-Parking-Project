import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _auth = Supabase.instance.client.auth;

  // تسجيل جديد
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signUp(
      email: email,
      password: password,
    );
  }

  // تسجيل دخول
  Future<AuthResponse> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // إرسال تأكيد إيميل
  Future<void> sendEmailVerification({
    required String email,
  }) async {
    await _auth.resend(
      type: OtpType.signup,
      email: email,
    );
  }

  // تسجيل خروج
  Future<void> logout() async {
    await _auth.signOut();
  }

  // المستخدم الحالي
  User? get currentUser => _auth.currentUser;
}