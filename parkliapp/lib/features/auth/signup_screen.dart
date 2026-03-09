import 'package:flutter/material.dart';
import 'package:parkliapp/features/auth/verify_phone_screen.dart';
import 'package:parkliapp/features/auth/signup_email_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFF237D8C),
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.84,
                      ),
                    ),
                    const SizedBox(height: 28),

                    const Text(
                      'Mobile Number',
                      style: TextStyle(
                        color: Color(0xFF237D8C),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.36,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const _CountryCodeField(),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Enter mobile number',
                              hintStyle: const TextStyle(
                                color: Color(0xFF777777),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE5E5E5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF237D8C),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const _OtpInfoBox(),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VerifyPhoneScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xA3237D8C),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.39,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    const _OrDivider(),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpEmailScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF237D8C),
                          size: 20,
                        ),
                        label: const Text(
                          'Continue with Email',
                          style: TextStyle(
                            color: Color(0xFF237D8C),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.39,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF237D8C),
                          side: const BorderSide(color: Color(0xFF237D8C)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
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
  const _TopBar();

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
            onPressed: () {
              // TODO: روحي للـ Home أو Login حسب تدفقك
            },
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

class _CountryCodeField extends StatelessWidget {
  const _CountryCodeField();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 91,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          CircleAvatar(radius: 11, backgroundColor: Color(0xFFE5E5E5)),
          SizedBox(width: 8),
          Text(
            '+966',
            style: TextStyle(
              color: Color(0xFF19515B),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.36,
            ),
          ),
          Spacer(),
          Icon(Icons.keyboard_arrow_down, color: Color(0xFF19515B), size: 16),
        ],
      ),
    );
  }
}

class _OtpInfoBox extends StatelessWidget {
  const _OtpInfoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Color(0xFF237D8C), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'You will receive an OTP code from ParkLi to confirm your number',
              style: TextStyle(
                color: Color(0xFF237D8C),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.39,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFE5E5E5), thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.36,
            ),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFE5E5E5), thickness: 1)),
      ],
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
