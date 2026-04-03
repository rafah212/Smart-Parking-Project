import 'package:flutter/material.dart';
import 'package:parkliapp/core/widgets/responsive_preview.dart';
import 'package:parkliapp/core/services/auth_service.dart';
import 'check_email.dart';

class ForgotPassword1 extends StatefulWidget {
  const ForgotPassword1({super.key});

  @override
  State<ForgotPassword1> createState() => _ForgotPassword1State();
}

class _ForgotPassword1State extends State<ForgotPassword1> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    final isValidEmail = RegExp(
      r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);

    if (!isValidEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid email')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService().sendPasswordResetEmail(email: email);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ForgotPasswordCheckEmail(email: email),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset email: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsivePreview(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 44,
                  child: Container(
                    width: 375,
                    height: 58,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE5E5E5), width: 0.5),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Forgot Password?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF3E3E3E),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 102,
                  child: Container(
                    width: 375,
                    height: 676,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 20,
                          top: 104,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_back_ios, size: 14, color: Color(0xFF237D8C)),
                                Text(
                                  'Back to login',
                                  style: TextStyle(
                                    color: Color(0xFF237D8C),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 20,
                          top: 144,
                          child: Text(
                            'Let’s reset your password.',
                            style: TextStyle(
                              color: Color(0xFF237D8C),
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 20,
                          top: 190,
                          child: SizedBox(
                            width: 335,
                            child: Text(
                              'We will email you a link you can use to reset your password.',
                              style: TextStyle(color: Color(0xFF777777), fontSize: 14),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 254,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email Address',
                                style: TextStyle(
                                  color: Color(0xFF237D8C),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 335,
                                height: 48,
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE5E5E5)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    hintText: 'Enter your email',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 348,
                          child: GestureDetector(
                            onTap: _isLoading ? null : _sendResetLink,
                            child: Container(
                              width: 335,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF72ACB6),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Next',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            width: 375,
                            height: 65,
                            color: const Color(0xFFF3F3F3),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              '2025, PARKLI. All rights reserved',
                              style: TextStyle(color: Color(0xFF777777), fontSize: 14),
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
      ),
    );
  }
}