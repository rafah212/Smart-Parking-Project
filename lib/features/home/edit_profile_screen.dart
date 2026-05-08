 import 'dart:io';
import 'dart:typed_data'; // ضروري لعرض الصور على الويب
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final ProfileService _profileService = ProfileService();
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  Uint8List? _webImage; // متغير لعرض الصورة المختار في الذاكرة (لحل مشكلة الويب)
  UserProfileData? _profile; // لتخزين بيانات البروفايل الحالية بما فيها الصورة

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final profile = await _profileService.getCurrentUserProfile(user.id);

      if (profile != null) {
        _profile = profile; // حفظ البيانات لعرض الصورة الحالية
        final fullName = profile.fullName.trim();
        final nameParts = fullName.isEmpty ? <String>[] : fullName.split(' ');

        if (nameParts.isNotEmpty) _firstNameController.text = nameParts.first;
        if (nameParts.length > 1) _lastNameController.text = nameParts.sublist(1).join(' ');
        _phoneController.text = profile.phoneNumber;
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (selectedImage != null) {
      // قراءة الصورة كـ Bytes لتعمل على المتصفح والجوال
      final bytes = await selectedImage.readAsBytes();
      setState(() {
        _webImage = bytes;
        _imageFile = File(selectedImage.path);
      });
    }
  }

  String _normalizeSaudiPhone(String rawPhone) {
    String digitsOnly = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.startsWith('966')) digitsOnly = digitsOnly.substring(3);
    if (digitsOnly.startsWith('0')) digitsOnly = digitsOnly.substring(1);
    return digitsOnly.isEmpty ? '' : '+966$digitsOnly';
  }

  Future<void> _saveProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final String fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim();
    final String phoneNumber = _normalizeSaudiPhone(_phoneController.text.trim());

    if (fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppData.translate('Please enter your name', 'يرجى إدخال الاسم'))));
      return;
    }

    setState(() => _isSaving = true);

    try {
      String? avatarUrl;

      // رفع الصورة إلى Supabase Storage إذا تم اختيار صورة جديدة
      if (_webImage != null) {
        final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final path = 'public/$fileName';

        // الرفع باستخدام bytes لضمان التوافق مع الويب
        await Supabase.instance.client.storage.from('avatars').uploadBinary(
              path,
              _webImage!,
              fileOptions: const FileOptions(upsert: true, contentType: 'image/jpeg'),
        ); 

        avatarUrl = Supabase.instance.client.storage.from('avatars').getPublicUrl(path);
      }

      // تحديث البيانات في جدول profiles عبر السيرفس
      await _profileService.upsertProfile(
        userId: user.id,
        fullName: fullName,
        email: user.email ?? '',
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl, // تمرير الرابط الجديد للسيرفس
      );

      if (!mounted) return;
      Navigator.pop(context, true); // العودة وإخبار الصفحة السابقة بضرورة التحديث
    } catch (e) {
      debugPrint("Save error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppData.translate('Failed to save changes', 'فشل حفظ التغييرات'))));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

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
            AppData.translate('Edit Profile', 'تعديل الملف الشخصي'),
            style: const TextStyle(color: Color(0xFF2A2A2A), fontSize: 18, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF237D8C)))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            AppData.translate('Add profile picture (Optional)', 'إضافة صورة شخصية (اختياري)'),
                            style: const TextStyle(fontSize: 14, color: Color(0xFF898989)),
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 100,
                              height: 100,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5FBFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF237D8C)),
                              ),
                              child: _webImage != null
                                  ? Image.memory(_webImage!, fit: BoxFit.cover) // عرض الصورة المختارة (bytes)
                                  : (_profile?.avatarUrl != null && _profile!.avatarUrl!.isNotEmpty)
                                      ? Image.network(_profile!.avatarUrl!, fit: BoxFit.cover) // عرض الصورة الحالية من السيرفر
                                      : const Icon(Icons.add_a_photo_outlined, color: Color(0xFF237D8C), size: 32),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(AppData.translate('First Name', 'الاسم الأول'), _firstNameController),
                    const SizedBox(height: 20),
                    _buildTextField(AppData.translate('Last Name', 'اسم العائلة'), _lastNameController),
                    const SizedBox(height: 20),
                    _buildTextField(AppData.translate('Mobile Number', 'رقم الجوال'), _phoneController, keyboardType: TextInputType.phone, hint: '05xxxxxxxx'),
                    const SizedBox(height: 50),
                   SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF237D8C),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: _isSaving
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                            : Text(AppData.translate('Save Changes', 'حفظ التغييرات'), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF414141))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textAlign: AppData.isArabic ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFD0D0D0), fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF237D8C))),
          ),
        ),
      ],
    );
  }
}