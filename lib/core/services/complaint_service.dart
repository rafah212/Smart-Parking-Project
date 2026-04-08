import 'package:supabase_flutter/supabase_flutter.dart';

class ComplaintService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> submitComplaint({
    required String userId,
    required String category,
    required String message,
  }) async {
    await _supabase.from('complaints').insert({
      'user_id': userId,
      'category': category,
      'message': message,
      'status': 'pending',
    });
  }
}