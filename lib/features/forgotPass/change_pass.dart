import 'package:flutter/material.dart';
import 'package:parkliapp/core/services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // إضافة التحكم في إظهار الباسورد القديم
  bool _isOldPasswordObscure = true;
  bool _isNewPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isLoading = false;

  // تعريف الـ Controllers الثلاثة (تأكدي من إضافة _oldPassController)
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final oldPassword = _oldPassController.text.trim();
    final newPassword = _newPassController.text.trim();
    final confirmPassword = _confirmPassController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    
    // 2. تنبيه لو الباسورد قصير
    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 3. تنبيه لو الباسورد الجديد والتاكيد غير متطابقين
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // استدعاء خدمة التحديث من الـ AuthService
      await AuthService().updatePassword(newPassword: newPassword);

      if (!mounted) return;

      // 4. إظهار نافذة النجاح (تنبيه تم الحفظ بنجاح)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Success'),
            ],
          ),
          content: const Text('Your password has been changed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق النافذة
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/loginEmail', // العودة لصفحة الدخول
                  (route) => false,
                );
              },
              child: const Text('OK', style: TextStyle(color: Color(0xFF237D8C), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }

    // ... باقي منطق التحقق  ...
   // setState(() => _isLoading = true);
    // منطق الـ AuthService...
   // setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    //    عشان يفرش ع اللابتوب
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- الهيدر الموحد (بنفس ستايل صديقتك) ---
            _CustomHeader(title: 'Change Password'),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // المربع الأول اللي كان مختفي (Old Password)
                    _buildPasswordField(
                      label: 'Old Password',
                      isObscure: _isOldPasswordObscure,
                      controller: _oldPassController,
                      onToggle: () => setState(() => _isOldPasswordObscure = !_isOldPasswordObscure),
                    ),
                    const SizedBox(height: 20),

                    // المربع الثاني (New Password)
                    _buildPasswordField(
                      label: 'New Password',
                      isObscure: _isNewPasswordObscure,
                      controller: _newPassController,
                      onToggle: () => setState(() => _isNewPasswordObscure = !_isNewPasswordObscure),
                    ),
                    const SizedBox(height: 20),

                    // المربع الثالث (Confirm Password)
                    _buildPasswordField(
                      label: 'Confirm Password',
                      isObscure: _isConfirmPasswordObscure,
                      controller: _confirmPassController,
                      onToggle: () => setState(() => _isConfirmPasswordObscure = !_isConfirmPasswordObscure),
                    ),

                    const SizedBox(height: 40),

                    // زر الحفظ (بعرض كامل ومرن)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF237D8C),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          elevation: 0,
                        ),
child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required bool isObscure,
    required VoidCallback onToggle,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF237D8C), fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}

// كلاس الهيدر الموحد لضمان التناسق
class _CustomHeader extends StatelessWidget {
  final String title;
  const _CustomHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 0.5)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF237D8C), size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Text(title, style: const TextStyle(color: Color(0xFF3E3E3E), fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}