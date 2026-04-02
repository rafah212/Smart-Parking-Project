import 'package:supabase_flutter/supabase_flutter.dart';

class PhoneAuthService {
  final _functions = Supabase.instance.client.functions;

  Future<void> sendOtp({
    required String phoneNumber,
  }) async {
    final response = await _functions.invoke(
      'twilio-verify',
      body: {
        'action': 'send',
        'phoneNumber': phoneNumber,
      },
    );

    final data = response.data;

    if (data == null || data['success'] != true) {
      throw Exception(data?['error'] ?? 'Failed to send OTP');
    }
  }

  Future<bool> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    final response = await _functions.invoke(
      'twilio-verify',
      body: {
        'action': 'check',
        'phoneNumber': phoneNumber,
        'code': code,
      },
    );

    final data = response.data;

    if (data == null || data['success'] != true) {
      throw Exception(data?['error'] ?? 'Failed to verify OTP');
    }

    final status = data['data']?['status'];
    return status == 'approved';
  }
}