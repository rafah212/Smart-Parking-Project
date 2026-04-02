import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _auth = Supabase.instance.client.auth;

  // تسجيل جديد بالإيميل
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: 'parkliapp://auth-callback',
    );
  }

  // تسجيل دخول بالإيميل
  Future<AuthResponse> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // إعادة إرسال رابط/رسالة تأكيد الإيميل
  Future<void> sendEmailVerification({
    required String email,
  }) async {
    await _auth.resend(
      type: OtpType.signup,
      email: email,
      emailRedirectTo: 'parkliapp://auth-callback',
    );
  }

  // تسجيل خروج
  Future<void> logout() async {
    await _auth.signOut();
  }

  // المستخدم الحالي
  User? get currentUser => _auth.currentUser;

  // هل الإيميل مؤكد؟
  bool get isEmailVerified {
    final user = _auth.currentUser;
    return user?.emailConfirmedAt != null;
  }

  // تحديث بيانات المستخدم
  Future<User?> refreshUser() async {
    await _auth.refreshSession();
    return _auth.currentUser;
  }
}