import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ
import 'dart:io'; // مطلوب للتعامل مع ملف الصورة
// --- ملاحظة: يجب إضافة حزمة image_picker للمشروع عبر الـ Terminal ---
// تنفيذ الأمر: flutter pub add image_picker
import 'package:image_picker/image_picker.dart'; 

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // متغير لتخزين الصورة المختارة
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // --- دالة اختيار الصورة من الاستوديو ---
  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _imageFile = File(selectedImage.path); // تخزين الصورة المختارة في المتغير
      });
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
            icon: Icon(
              AppData.isArabic ? Icons.arrow_back_ios_new : Icons.arrow_back_ios_new, 
              color: const Color(0xFF414141), 
              size: 20
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppData.translate('Edit Profile', 'تعديل الملف الشخصي'),
            style: const TextStyle(color: Color(0xFF2A2A2A), fontSize: 18, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // قسم الصورة الشخصية
              Center(
                child: Column(
                  children: [
                    Text(
                      AppData.translate('Add profile picture (Optional)', 'إضافة صورة شخصية (اختياري)'), 
                      style: const TextStyle(fontSize: 14, color: Color(0xFF898989))
                    ),
                    const SizedBox(height: 15),
                    
                    // غلفنا مربع الصورة بـ GestureDetector لجعله قابلاً للضغط
                    GestureDetector(
                      onTap: _pickImage, // عند الضغط، نفتح الاستوديو
                      child: Container(
                        width: 100, height: 100,
                        clipBehavior: Clip.antiAlias, // لضمان قص الصورة بشكل دائري داخل الإطار
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5FBFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF237D8C)),
                        ),
                        child: _imageFile != null
                            ? Image.file(_imageFile!, fit: BoxFit.cover) // عرض الصورة المختارة
                            : const Icon(Icons.add_a_photo_outlined, color: Color(0xFF237D8C), size: 32), // الأيقونة الافتراضية
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // حقول الإدخال
              _buildTextField(
                AppData.translate('First Name', 'الاسم الأول'), 
                _firstNameController,
                hint: AppData.translate('Enter your first name', 'أدخل اسمك الأول'),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                AppData.translate('Last Name', 'اسم العائلة'), 
                _lastNameController,
                hint: AppData.translate('Enter your last name', 'أدخل اسم العائلة'),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                AppData.translate('Mobile Number', 'رقم الجوال'), 
                _phoneController, 
                keyboardType: TextInputType.phone,
                hint: '05xxxxxxxx',
              ),
              
              const SizedBox(height: 50),
              
              // زر الحفظ
              SizedBox(
                width: double.infinity, height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // نرسل الاسم الجديد إذا كتب المستخدم شيئاً، وإلا نرسل نصاً فارغاً
                    String fullName = "${_firstNameController.text} ${_lastNameController.text}".trim();
                    Navigator.pop(context, fullName.isNotEmpty ? fullName : null); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF237D8C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: Text(
                    AppData.translate('Save Changes', 'حفظ التغييرات'), 
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)
                  ),
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
        Text(
          label, 
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF414141))
        ),
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
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), 
              borderSide: const BorderSide(color: Color(0xFFE0E0E0))
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), 
              borderSide: const BorderSide(color: Color(0xFF237D8C))
            ),
          ),
        ),
      ],
    );
  }
}