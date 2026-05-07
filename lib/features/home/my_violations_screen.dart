import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:parkliapp/app_data.dart';

class MyViolationsScreen extends StatefulWidget {
  const MyViolationsScreen({super.key});

  @override
  State<MyViolationsScreen> createState() => _MyViolationsScreenState();
}

class _MyViolationsScreenState extends State<MyViolationsScreen> {
  // تم إزالة متغير التحقق وكنترولر النص لعدم الحاجة لهما بعد الآن

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
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF414141), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppData.translate('My Violations', 'مخالفاتي المرورية'),
            style: const TextStyle(color: Color(0xFF2A2A2A), fontSize: 18, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        // يتم استدعاء قائمة المخالفات مباشرة هنا
        body: _buildViolationsList(),
      ),
    );
  }

  Widget _buildViolationsList() {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    // التأكد من وجود مستخدم مسجل دخول قبل محاولة جلب البيانات
    if (user == null) {
      return Center(
        child: Text(AppData.translate('Please login to view violations', 'يرجى تسجيل الدخول لعرض المخالفات')),
      );
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase
          .from('violations')
          .stream(primaryKey: ['id'])
          .eq('user_id', user.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF237D8C)));
        }
        
        final violations = snapshot.data!;
        
        if (violations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_turned_in_rounded, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 15),
                Text(
                  AppData.translate('No violations found.', 'لا توجد مخالفات مسجلة.'),
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
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
            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 2,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFEBEE),
                  child: Icon(Icons.report_problem, color: Colors.red),
                ),
                title: Text(
                  v['violation_type'] ?? AppData.translate('Violation', 'مخالفة'), 
                  style: const TextStyle(fontWeight: FontWeight.bold)
                ),
                subtitle: Text(v['created_at'].toString().substring(0, 10)),
                trailing: Text(
                  "${v['amount']} SAR", 
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ),
            );
          },
        );
      },
    );
  }
}