import 'package:flutter/material.dart';
import 'package:parkliapp/features/location/location_permission_screen.dart';

class CompleteInfoScreen extends StatelessWidget {
  const CompleteInfoScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

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
                      'Complete your info',
                      style: TextStyle(
                        color: Color(0xFF237D8C),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.84,
                      ),
                    ),
                    const SizedBox(height: 28),

                    const _FieldLabel('First Name'),
                    const SizedBox(height: 8),
                    const _CustomTextField(hintText: 'Enter first name'),

                    const SizedBox(height: 16),

                    const _FieldLabel('Last Name'),
                    const SizedBox(height: 8),
                    const _CustomTextField(hintText: 'Enter last name'),

                    const SizedBox(height: 16),

                    const _FieldLabel('Mobile Number'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const _CountryCodeField(),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _CustomTextField(
                            hintText: phoneNumber,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color(0xFF237D8C),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.35,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'By selecting done, I agree to ParkLi’s terms of service,\npayment terms of service & privacy policy',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LocationPermissionScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA3D3DB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.39,
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
          const Text(
            'Step 1/2',
            style: TextStyle(
              color: Color(0xFF8EB8C0),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF237D8C),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  const _CustomTextField({required this.hintText, this.readOnly = false});

  final String hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF777777),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: readOnly ? const Color(0xFFF8F8F8) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF237D8C)),
        ),
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
        color: const Color(0xFFF8F8F8),
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
            ),
          ),
          Spacer(),
          Icon(Icons.keyboard_arrow_down, color: Color(0xFF19515B), size: 16),
        ],
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
