import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/profile_service.dart';
import 'package:parkliapp/features/location/location_permission_screen.dart';

class CompleteInfoEmailScreen extends StatefulWidget {
  const CompleteInfoEmailScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<CompleteInfoEmailScreen> createState() =>
      _CompleteInfoEmailScreenState();
}

class _CompleteInfoEmailScreenState extends State<CompleteInfoEmailScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppData.translate(
              'Please complete all fields',
              'يرجى إكمال جميع الحقول',
            ),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppData.translate(
                'No authenticated user found',
                'لم يتم العثور على مستخدم مسجل',
              ),
            ),
          ),
        );
        return;
      }

      final profileService = ProfileService();

      await profileService.upsertProfile(
        userId: user.id,
        fullName: '$firstName $lastName',
        email: email,
        phoneNumber: '',
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LocationPermissionScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppData.translate(
              'Failed to save data',
              'فشل في حفظ البيانات',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
              const _TopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppData.translate('Complete your info', 'أكمل معلوماتك'),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.84,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _FieldLabel(
                        AppData.translate('First Name', 'الاسم الأول'),
                      ),
                      const SizedBox(height: 8),
                      _CustomTextField(
                        controller: _firstNameController,
                        hintText: AppData.translate(
                          'Enter first name',
                          'أدخل الاسم الأول',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _FieldLabel(
                        AppData.translate('Last Name', 'اسم العائلة'),
                      ),
                      const SizedBox(height: 8),
                      _CustomTextField(
                        controller: _lastNameController,
                        hintText: AppData.translate(
                          'Enter last name',
                          'أدخل اسم العائلة',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _FieldLabel(
                        AppData.translate('Email Address', 'البريد الإلكتروني'),
                      ),
                      const SizedBox(height: 8),
                      _CustomTextField(
                        controller: _emailController,
                        hintText: AppData.translate(
                          'Enter email address',
                          'أدخل البريد الإلكتروني',
                        ),
                        readOnly: true,
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
                        child: Text(
                          AppData.translate(
                            'By selecting done, I agree to PARKLI\'s terms of service,\npayment terms of service & privacy policy',
                            'باختيارك "تم"، فإنك توافق على شروط خدمة باركلي،\nوشروط دفع الخدمة وسياسة الخصوصية',
                          ),
                          style: const TextStyle(
                            color: Color(0xFF237D8C),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.35,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _goNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA3D3DB),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            disabledBackgroundColor:
                                const Color(0xFFA3D3DB).withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  AppData.translate('Next', 'التالي'),
                                  style: const TextStyle(
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
          Text(
            AppData.translate('Step 1/2', 'خطوة ١/٢'),
            style: const TextStyle(
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
  const _CustomTextField({
    required this.controller,
    required this.hintText,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      textAlign: AppData.isArabic ? TextAlign.right : TextAlign.left,
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