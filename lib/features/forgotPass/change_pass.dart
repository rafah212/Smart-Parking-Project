import 'package:flutter/material.dart';
import 'package:parkliapp/core/services/auth_service.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isOldPasswordObscure = true;
  bool _isNewPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isLoading = false;

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
        SnackBar(content: Text(AppData.translate('Please fill all fields', 'يرجى ملء جميع الحقول'))),
      );
      return;
    }
    
    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppData.translate('Password must be at least 6 characters', 'يجب أن تكون كلمة المرور 6 خانات على الأقل')),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppData.translate('Passwords do not match!', 'كلمات المرور غير متطابقة!')),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService().updatePassword(newPassword: newPassword);

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 10),
              Text(AppData.translate('Success', 'نجاح')),
            ],
          ),
          content: Text(AppData.translate(
            'Your password has been changed successfully.', 
            'تم تغيير كلمة المرور الخاصة بك بنجاح.'
          )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/loginEmail', 
                  (route) => false,
                );
              },
              child: Text(
                AppData.translate('OK', 'موافق'), 
                style: const TextStyle(color: Color(0xFF237D8C), fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppData.translate('Error: $e', 'خطأ: $e')), 
          backgroundColor: Colors.red
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _CustomHeader(title: AppData.translate('Change Password', 'تغيير كلمة المرور')),
                Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildPasswordField(
                        label: AppData.translate('Old Password', 'كلمة المرور القديمة'),
                        hint: AppData.translate('Enter old password', 'أدخل كلمة المرور القديمة'),
                        isObscure: _isOldPasswordObscure,
                        controller: _oldPassController,
                        onToggle: () => setState(() => _isOldPasswordObscure = !_isOldPasswordObscure),
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        label: AppData.translate('New Password', 'كلمة المرور الجديدة'),
                        hint: AppData.translate('Enter new password', 'أدخل كلمة المرور الجديدة'),
                        isObscure: _isNewPasswordObscure,
                        controller: _newPassController,
                        onToggle: () => setState(() => _isNewPasswordObscure = !_isNewPasswordObscure),
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        label: AppData.translate('Confirm Password', 'تأكيد كلمة المرور'),
                        hint: AppData.translate('Confirm your new password', 'أكد كلمة المرور الجديدة'),
                        isObscure: _isConfirmPasswordObscure,
                        controller: _confirmPassController,
                        onToggle: () => setState(() => _isConfirmPasswordObscure = !_isConfirmPasswordObscure),
                      ),
                      const SizedBox(height: 40),
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
                              : Text(
                                  AppData.translate('Save', 'حفظ'), 
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
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
          textAlign: AppData.isArabic ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            hintText: hint,
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
            left: AppData.isArabic ? null : 10,
            right: AppData.isArabic ? 10 : null,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: Icon(
                AppData.isArabic ? Icons.arrow_back_ios_new : Icons.arrow_back_ios, 
                color: const Color(0xFF237D8C), 
                size: 20
              ),
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