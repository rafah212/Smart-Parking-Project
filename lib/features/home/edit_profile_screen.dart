import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // المتحكمات (نضع قيم افتراضية مبدئية)
  final TextEditingController _firstNameController = TextEditingController(text: 'Asayl');
  final TextEditingController _lastNameController = TextEditingController(text: 'Falh');
  final TextEditingController _phoneController = TextEditingController(text: '0569225194');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF414141), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Color(0xFF2A2A2A), fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
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
                  const Text('Add profile picture (Optional)', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', color: Color(0xFF898989))),
                  const SizedBox(height: 15),
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5FBFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF237D8C)),
                    ),
                    child: const Icon(Icons.add_a_photo_outlined, color: Color(0xFF237D8C), size: 32),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField('First Name', _firstNameController),
            const SizedBox(height: 20),
            _buildTextField('Last Name', _lastNameController),
            const SizedBox(height: 20),
            _buildTextField('Mobile Number', _phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 50),
            
            // زر الحفظ مع إرسال البيانات للخلف
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton(
                onPressed: () {
                  // دمج الاسم الأول والأخير لإرسالهما
                  String newName = "${_firstNameController.text} ${_lastNameController.text}";
                  Navigator.pop(context, newName); // إغلاق الصفحة وإرجاع الاسم
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF237D8C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF414141), fontFamily: 'Poppins')),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true, fillColor: const Color(0xFFFAFAFA),enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF237D8C))),
          ),
        ),
      ],
    );
  }
}