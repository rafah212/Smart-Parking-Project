import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:parkliapp/app_data.dart';

class MyViolationsScreen extends StatefulWidget {
  const MyViolationsScreen({super.key});

  @override
  State<MyViolationsScreen> createState() => _MyViolationsScreenState();
}

class _MyViolationsScreenState extends State<MyViolationsScreen> {
  bool isVerified = false; 
  final TextEditingController _idController = TextEditingController();

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
        body: isVerified ? _buildViolationsList() : _buildVerificationUI(),
      ),
    );
  }

  Widget _buildVerificationUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 160, height: 160,
              decoration: const BoxDecoration(color: Color(0xFFF5F5F5), shape: BoxShape.circle),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.directions_car_filled_rounded, size: 80, color: const Color(0xFF237D8C).withOpacity(0.2)),
                  const Icon(Icons.assignment_late_rounded, size: 60, color: Color(0xFF237D8C)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(AppData.translate('Easily view your violations', 'استعرض مخالفاتك بكل سهولة'),
              textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A485F))),
          const SizedBox(height: 15),
          Text(AppData.translate('Verify your account through the Nafath service to get direct access to your registered violation details.',
                  'قم بتوثيق حسابك عبر خدمة نفاذ للوصول المباشر إلى تفاصيل مخالفاتك المسجلة برقم هويتك.'),
              textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Color(0xFF898989), height: 1.5)),
          const SizedBox(height: 50),
          SizedBox(
            width: double.infinity, height: 55,
            child: ElevatedButton(
              onPressed: () => _showNafathSheet(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF237D8C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: Text(AppData.translate('Verify Account', 'توثيق الحساب'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViolationsList() {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase.from('violations').stream(primaryKey: ['id']).eq('user_id', user!.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text(snapshot.error.toString()));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final violations = snapshot.data!;
        if (violations.isEmpty) {
          return Center(
            child: Text(AppData.translate('No violations found.', 'لا توجد مخالفات مسجلة.')),
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
                title: Text(v['violation_type'] ?? 'Violation', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(v['created_at'].toString().substring(0, 10)),
                trailing: Text("${v['amount']} SAR", 
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            );
          },
        );
      },
    );
  }

  void _showNafathSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 20, right: 20),
          decoration: const BoxDecoration(color: Color(0xFF0F0F0F), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('نفاذ', style: TextStyle(color: Color(0xFF237D8C), fontSize: 45, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(AppData.translate('Verification via Nafath App\nPlease enter your Mobile Number', 
                  'التحقق عبر تطبيق نفاذ\nيرجى إدخال رقم الجوال المسجل'), 
                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 30),
              TextField(
                controller: _idController,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: AppData.translate('Enter Mobile Number', 'أدخل رقم الجوال'),
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true, fillColor: Colors.white.withOpacity(0.05), 
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final supabase = Supabase.instance.client;
                    final user = supabase.auth.currentUser;

                    final userData = await supabase.from('profiles').select('phone_number').eq('id', user!.id).single();
                    String registeredPhone = userData['phone_number'].toString();
                    String enteredPhone = _idController.text.trim();

                    if (registeredPhone.contains(enteredPhone) && enteredPhone.isNotEmpty) {
                      Navigator.pop(context);
                      setState(() { isVerified = true; });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppData.translate('Invalid verification details', 'بيانات التحقق غير صحيحة'))),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF237D8C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text(AppData.translate('Next', 'التالي'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}