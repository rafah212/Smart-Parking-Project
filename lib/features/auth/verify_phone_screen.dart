import 'package:flutter/material.dart';
import 'package:parkliapp/features/auth/complete_info_screen.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key, this.phoneNumber = '+966 567891234'});

  final String phoneNumber;

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (_) => TextEditingController());
    _focusNodes = List.generate(4, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _controllers.map((e) => e.text).join();

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < _focusNodes.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  void _onBackspace(String value, int index) {
    if (value.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyCode() {
    final code = _otpCode;

    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 4-digit code')),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Entered OTP: $code')));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CompleteInfoScreen(phoneNumber: widget.phoneNumber),
      ),
    );
  }

  void _resendCode() {
    // TODO: resend OTP logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('OTP code resent')));
  }

  void _skip() {
    // TODO: روحي للصفحة المناسبة عندك
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onSkip: _skip),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verify your phone number',
                      style: TextStyle(
                        color: Color(0xFF237D8C),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.84,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Enter the code that was sent to\n',
                            style: TextStyle(
                              color: Color(0xFF237D8C),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              letterSpacing: -0.42,
                            ),
                          ),
                          TextSpan(
                            text: widget.phoneNumber,
                            style: const TextStyle(
                              color: Color(0xFF237D8C),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              letterSpacing: -0.42,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: List.generate(
                        4,
                        (index) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: index == 3 ? 0 : 10,
                            ),
                            child: _OtpInputBox(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  _onBackspace(value, index);
                                } else {
                                  _onOtpChanged(value, index);
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _verifyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF237D8C),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.39,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Did not receive the code?',
                      style: TextStyle(
                        color: Color(0xFF237D8C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        letterSpacing: -0.42,
                      ),
                    ),

                    const SizedBox(height: 16),

                    OutlinedButton(
                      onPressed: _resendCode,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF237D8C),
                        side: const BorderSide(color: Color(0xFF237D8C)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Resend Code',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.39,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const _BottomHandle(),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF237D8C),
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF237D8C),
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            label: const Text(
              'Skip',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.42,
              ),
            ),
            icon: const Icon(Icons.arrow_forward_ios, size: 14),
            iconAlignment: IconAlignment.end,
          ),
        ],
      ),
    );
  }
}

class _OtpInputBox extends StatelessWidget {
  const _OtpInputBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          color: Color(0xFF237D8C),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF237D8C), width: 1.4),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _BottomHandle extends StatelessWidget {
  const _BottomHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      color: Colors.white,
      alignment: const Alignment(0, 0.3),
      child: Container(
        width: 134,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
