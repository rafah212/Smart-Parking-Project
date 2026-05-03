import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _auth = Supabase.instance.client.auth;

  /// إرسال رمز تحقق إلى الإيميل
  /// يستخدم للتسجيل أو تسجيل الدخول بدون كلمة مرور
  Future<void> sendEmailOtp({
    required String email,
    bool shouldCreateUser = true,
  }) async {
    await _auth.signInWithOtp(
      email: email.trim().toLowerCase(),
      shouldCreateUser: shouldCreateUser,
    );
  }

  /// التحقق من رمز الإيميل
  Future<AuthResponse> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    return await _auth.verifyOTP(
      email: email.trim().toLowerCase(),
      token: otp.trim(),
      type: OtpType.email,
    );
  }

  /// تسجيل بكلمة مرور -  موجود احتياطًا
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signUp(
      email: email.trim().toLowerCase(),
      password: password,
      emailRedirectTo: 'parkliapp://auth-callback',
    );
  }

  ///دخول بكلمه مرور
  Future<AuthResponse> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  /// إعادة إرسال رمز تحقق للإيميل
  Future<void> resendEmailOtp({
    required String email,
  }) async {
    await _auth.resend(
      type: OtpType.email,
      email: email.trim().toLowerCase(),
    );
  }

  /// الطريقة القديمة لإعادة إرسال رابط تحقق التسجيل
  Future<void> sendEmailVerification({
    required String email,
  }) async {
    await _auth.resend(
      type: OtpType.signup,
      email: email.trim().toLowerCase(),
      emailRedirectTo: 'parkliapp://auth-callback',
    );
  }

  /// إرسال رابط إعادة تعيين كلمة المرور
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _auth.resetPasswordForEmail(
      email.trim().toLowerCase(),
      redirectTo: 'parkliapp://reset-password',
    );
  }

  /// تحديث كلمة المرور بعد فتح رابط reset-password
  Future<UserResponse> updatePassword({
    required String newPassword,
  }) async {
    return await _auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  bool get isEmailVerified {
    final user = _auth.currentUser;
    return user?.emailConfirmedAt != null;
  }

  Future<User?> refreshUser() async {
    await _auth.refreshSession();
    return _auth.currentUser;
  }
}
