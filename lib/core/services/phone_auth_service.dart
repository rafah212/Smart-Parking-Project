import 'dart:convert';
import 'package:http/http.dart' as http;

class PhoneAuthService {
  static const String _baseUrl = 'https://api.authentica.sa/api/v2';

  static const String _apiKey = String.fromEnvironment(
    'AUTHENTICA_API_KEY',
    defaultValue: '',
  );

  static const int otpLength = 4;

  Map<String, String> _headers() {
    if (_apiKey.isEmpty) {
      throw Exception(
        'Authentica API key is missing. Run with --dart-define=AUTHENTICA_API_KEY=YOUR_KEY',
      );
    }

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Authorization': _apiKey,
    };
  }

  Future<void> sendOtp({
    required String phoneNumber,
  }) async {
    final normalizedPhone = _normalizePhone(phoneNumber);

    final response = await http.post(
      Uri.parse('$_baseUrl/send-otp'),
      headers: _headers(),
      body: jsonEncode({
        'method': 'sms',
        'phone': normalizedPhone,
      }),
    );

    final body = _decode(response.body);

    print('SEND OTP STATUS: ${response.statusCode}');
    print('SEND OTP BODY: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractMessage(body, 'Failed to send OTP'));
    }

    if (body is Map<String, dynamic>) {
      final success = body['success'];
      final status = body['status']?.toString().toLowerCase();

      if (success == false || status == 'failed' || status == 'error') {
        throw Exception(_extractMessage(body, 'Failed to send OTP'));
      }
    }
  }

  Future<bool> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final normalizedPhone = _normalizePhone(phoneNumber);
    final cleanOtp = otp.trim();

    if (cleanOtp.length != otpLength) {
      throw Exception('OTP must be $otpLength digits');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/verify-otp'),
      headers: _headers(),
      body: jsonEncode({
        'phone': normalizedPhone,
        'otp': cleanOtp,
      }),
    );

    final body = _decode(response.body);

    print('VERIFY OTP STATUS: ${response.statusCode}');
    print('VERIFY OTP BODY: ${response.body}');
    print('VERIFY PHONE: $normalizedPhone');
    print('VERIFY OTP: $cleanOtp');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractMessage(body, 'Verification failed'));
    }

    if (body is Map<String, dynamic>) {
      final success = body['success'];
      final verified = body['verified'];
      final status = body['status']?.toString().toLowerCase();

      if (success == false) {
        throw Exception(_extractMessage(body, 'Verification failed'));
      }

      if (verified == false) {
        throw Exception(_extractMessage(body, 'Incorrect or expired OTP'));
      }

      if (status == 'failed' || status == 'error') {
        throw Exception(_extractMessage(body, 'Verification failed'));
      }

      if (status == 'invalid' || status == 'expired') {
        throw Exception(_extractMessage(body, 'Incorrect or expired OTP'));
      }
    }

    return true;
  }

  String _normalizePhone(String phoneNumber) {
    var phone = phoneNumber.trim().replaceAll(RegExp(r'[^0-9+]'), '');

    if (phone.startsWith('00')) {
      phone = '+${phone.substring(2)}';
    }

    if (phone.startsWith('966')) {
      phone = '+$phone';
    }

    if (!phone.startsWith('+')) {
      throw Exception('Phone number must include country code');
    }

    return phone;
  }

  dynamic _decode(String source) {
    try {
      return jsonDecode(source);
    } catch (_) {
      return source;
    }
  }

  String _extractMessage(dynamic body, String fallback) {
    if (body is Map<String, dynamic>) {
      final message = body['message'] ??
          body['error'] ??
          body['errors'] ??
          body['detail'] ??
          body['title'] ??
          body['status'];

      if (message != null) {
        if (message is List) {
          return message.join(', ');
        }
        if (message is Map) {
          return message.values.join(', ');
        }
        return message.toString();
      }
    }

    if (body is String && body.trim().isNotEmpty) {
      return body;
    }

    return fallback;
  }
}
