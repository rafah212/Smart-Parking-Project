import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ
import 'home_screen.dart'; 

class ComplainScreen extends StatefulWidget {
  const ComplainScreen({super.key});

  @override
  State<ComplainScreen> createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  // تعريف الخيارات بنظام الترجمة
  late String selectedValue;
  final List<String> complainOptions = ['Parking is not available', 'Another'];
  
  // التحكم في النص المكتوب
  final TextEditingController _complainController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedValue = complainOptions[0];
  }

  @override
  void dispose() {
    _complainController.dispose();
    super.dispose();
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return Directionality(
          textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: AppData.isArabic ? Alignment.topLeft : Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF5A5A5A), size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 80,
                    color: Color(0xFF43A048),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppData.translate('Send successful', 'تم الإرسال بنجاح'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppData.translate(
                      'Your complain has been send successful', 
                      'لقد تم إرسال بلاغك بنجاح، وسنقوم بمراجعته قريباً'
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF898989)),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF237D8C),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: Text(
                        AppData.translate('Back Home', 'العودة للرئيسية'),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
            AppData.translate('Complain', 'تقديم بلاغ'),
            style: const TextStyle(color: Color(0xFF2A2A2A), fontSize: 18, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              // القائمة المنسدلة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFB8B8B8)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF414141)),
                    isExpanded: true,
                    style: const TextStyle(color: Color(0xFF414141), fontSize: 16),
                    items: complainOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option == 'Parking is not available' 
                          ? AppData.translate('Parking is not available', 'الموقف غير متاح')
                          : AppData.translate('Another', 'أخرى')
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => selectedValue = newValue);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // صندوق النص المعدل (بدون شرط الـ 10 حروف)
              Container(
                width: double.infinity,
                height: 150,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFB8B8B8)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _complainController,
                  maxLines: 5,
                  textAlign: AppData.isArabic ? TextAlign.right : TextAlign.left,
                  decoration: InputDecoration(
                    hintText: AppData.translate(
                      'Write your complain here', 
                      'اكتب تفاصيل البلاغ هنا...'
                    ),
                    hintStyle: const TextStyle(color: Color(0xFFD0D0D0), fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // زر الإرسال
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // هنا مستقبلاً نضع كود إرسال البيانات للـ Dashboard
                    // String complainText = _complainController.text;
                    // String category = selectedValue;
                    
                    _showSuccessPopup();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF237D8C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: Text(
                    AppData.translate('Submit', 'إرسال'),
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}