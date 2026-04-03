import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _auth = Supabase.instance.client.auth;

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

  Future<AuthResponse> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendEmailVerification({
    required String email,
  }) async {
    await _auth.resend(
      type: OtpType.signup,
      email: email,
      emailRedirectTo: 'parkliapp://auth-callback',
    );
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _auth.resetPasswordForEmail(
      email,
      redirectTo: 'parkliapp://reset-password',
    );
  }

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