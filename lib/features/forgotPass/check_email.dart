import 'package:flutter/material.dart';
import 'package:parkliapp/core/services/auth_service.dart';
import 'package:parkliapp/core/widgets/responsive_preview.dart';

class ForgotPasswordCheckEmail extends StatefulWidget {
  final String email;

  const ForgotPasswordCheckEmail({
    super.key,
    required this.email,
  });

  @override
  State<ForgotPasswordCheckEmail> createState() => _ForgotPasswordCheckEmailState();
}

class _ForgotPasswordCheckEmailState extends State<ForgotPasswordCheckEmail> {
  bool _isResending = false;

  Future<void> _resendEmail() async {
    setState(() => _isResending = true);

    try {
      await AuthService().sendPasswordResetEmail(email: widget.email);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent again')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend email: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsivePreview(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF237D8C), size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Forgot Password?',
            style: TextStyle(
              color: Color(0xFF3E3E3E),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.5),
            child: Container(color: const Color(0xFFE5E5E5), height: 0.5),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Icon(
                      Icons.mark_email_read_outlined,
                      size: 50,
                      color: Color(0xFF237D8C),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Check your email',
                      style: TextStyle(
                        color: Color(0xFF237D8C),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'We sent a link to ',
                            style: TextStyle(color: Color(0xFF777777), fontSize: 14),
                          ),
                          TextSpan(
                            text: '${widget.email} ',
                            style: const TextStyle(
                              color: Color(0xFF777777),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: 'to help set up a new password if you have an account with us.',
                            style: TextStyle(color: Color(0xFF777777), fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Check your spam folder if you don’t see the email.',
                      style: TextStyle(color: Color(0xFF777777), fontSize: 14),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _isResending ? null : _resendEmail,
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF237D8C),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: _isResending
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Resend Email Address',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 65,
              color: const Color(0xFFF3F3F3),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              child: const Text(
                '2025, PARKLI. All rights reserved',
                style: TextStyle(color: Color(0xFF777777), fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}