import 'package:shared_preferences/shared_preferences.dart';

class LocalSessionService {
  static const String _phoneKey = 'logged_phone_number';
  static const String _authTypeKey = 'auth_type';

  Future<void> savePhoneSession(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneKey, phoneNumber);
    await prefs.setString(_authTypeKey, 'phone');
  }

  Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneKey);
  }

  Future<String?> getAuthType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTypeKey);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_phoneKey);
    await prefs.remove(_authTypeKey);
  }
}