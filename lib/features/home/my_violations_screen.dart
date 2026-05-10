import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/app_session_service.dart';

class MyViolationsScreen extends StatefulWidget {
  const MyViolationsScreen({super.key});

  @override
  State<MyViolationsScreen> createState() => _MyViolationsScreenState();
}

class _MyViolationsScreenState extends State<MyViolationsScreen> {
  final AppSessionService _appSessionService = AppSessionService();

  late final Future<AppUserSession?> _sessionFuture;

  @override
  void initState() {
    super.initState();
    _sessionFuture = _appSessionService.getCurrentSession();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF414141),
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppData.translate('My Violations', 'مخالفاتي المرورية'),
            style: const TextStyle(
              color: Color(0xFF2A2A2A),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: _buildViolationsList(),
      ),
    );
  }

  Widget _buildViolationsList() {
    final supabase = Supabase.instance.client;

    return FutureBuilder<AppUserSession?>(
      future: _sessionFuture,
      builder: (context, sessionSnapshot) {
        if (sessionSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF237D8C),
            ),
          );
        }

        final session = sessionSnapshot.data;

        if (session == null) {
          return Center(
            child: Text(
              AppData.translate(
                'Please login to view violations',
                'يرجى تسجيل الدخول لعرض المخالفات',
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: supabase
              .from('violations')
              .stream(primaryKey: ['id']).eq('user_id', session.userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF237D8C),
                ),
              );
            }

            final violations = snapshot.data ?? [];

            if (violations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_turned_in_rounded,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      AppData.translate(
                        'No violations found.',
                        'لا توجد مخالفات مسجلة.',
                      ),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: violations.length,
              itemBuilder: (context, index) {
                final v = violations[index];

                final createdAt = v['created_at']?.toString() ?? '';
                final dateText = createdAt.length >= 10
                    ? createdAt.substring(0, 10)
                    : createdAt;

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFFFEBEE),
                      child: Icon(
                        Icons.report_problem,
                        color: Colors.red,
                      ),
                    ),
                    title: Text(
                      v['violation_type'] ??
                          AppData.translate('Violation', 'مخالفة'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(dateText),
                    trailing: Text(
                      "${v['amount'] ?? 0} SAR",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
