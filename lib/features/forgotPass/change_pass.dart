import 'package:flutter/material.dart';
import 'package:parkliapp/core/widgets/responsive_preview.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // متغيرات للتحكم في ظهور كلمة المرور لكل حقل
  bool _isOldPasswordObscure = true;
  bool _isNewPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  // وحدات تحكم للنصوص (اختياري لو بغيتي تاخذين القيم لاحقاً)
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ResponsivePreview(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF414141), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Change Password',
            style: TextStyle(
              color: Color(0xFF2A2A2A),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 30),
              
              // حقل كلمة المرور القديمة
              _buildPasswordField(
                label: 'Old Password',
                isObscure: _isOldPasswordObscure,
                controller: _oldPassController,
                onToggle: () {
                  setState(() => _isOldPasswordObscure = !_isOldPasswordObscure);
                },
              ),
              const SizedBox(height: 16),

              // حقل كلمة المرور الجديدة
              _buildPasswordField(
                label: 'New Password',
                isObscure: _isNewPasswordObscure,
                controller: _newPassController,
                onToggle: () {
                  setState(() => _isNewPasswordObscure = !_isNewPasswordObscure);
                },
              ),
              const SizedBox(height: 16),

              // حقل تأكيد كلمة المرور
              _buildPasswordField(
                label: 'Confirm Password',
                isObscure: _isConfirmPasswordObscure,
                controller: _confirmPassController,
                onToggle: () {
                  setState(() => _isConfirmPasswordObscure = !_isConfirmPasswordObscure);
                },
              ),
              
              const SizedBox(height: 32),

              // --- زر Save ---
              GestureDetector(
                onTap: () {
                  // هنا نضع التنبيه عند الضغط على حفظ
                  _handleSave();
                },
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF237D8C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة معالجة الحفظ (عرض رسالة نجاح)
  void _handleSave() {
    if (_newPassController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    // عرض تنبيه بسيط عند النجاح
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Your password has been changed successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق التنبيه
              Navigator.pop(context); // الرجوع لصفحة اللوج ان
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Widget مساعد لبناء الحقول مع خاصية العين
  Widget _buildPasswordField({
    required String label,
    required bool isObscure,
    required VoidCallback onToggle,
    required TextEditingController controller,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFB8B8B8)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure, // هنا يتم إخفاء أو إظهار النص
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Color(0xFFD0D0D0), fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: IconButton(
            icon: Icon(
              isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color(0xFFD0D0D0),
            ),
            onPressed: onToggle, // عند الضغط على العين
          ),
        ),
      ),
    );
  }
}