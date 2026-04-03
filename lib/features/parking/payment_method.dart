import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // النظام الجديد: Scaffold مرن يفرش على أي شاشة
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. الهيدر الموحد (الفرش) ---
            _CustomHeader(title: 'Payment method'),

            // --- 2. محتوى الصفحة القابل للتمرير (الفرش) ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select payment method',
                      style: TextStyle(
                        color: Color(0xFF25054D),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // خيارات الدفع (Apple Pay, etc)
                    _buildPaymentOption('Apple pay'),
                    _buildPaymentOption('Stc pay'),
                    _buildPaymentOption('CARD'),

                    const SizedBox(height: 40),

                    // --- 3. عرض بطاقة الائتمان الزرقاء (باستخدام الصورة والبيانات) ---
                    _buildCreditCardView(),
                    
                    const SizedBox(height: 40),

                    // --- 4. عرض المجموع (Total) ---
                    _buildTotalCard(),
                  ],
                ),
              ),
            ),

            // --- 5. زر الدفع النهائي (Pay) (ثابت في الأسفل) ---
            _buildBottomPayButton(context),
          ],
        ),
      ),
    );
  }

  // ويدجت خيارات الدفع
  Widget _buildPaymentOption(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FCFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF677191), fontSize: 16)),
          const Icon(Icons.add, color: Color(0xFF237D8C), size: 20),
        ],
      ),
    );
  }

  // ويدجت بطاقة الائتمان الزرقاء (الفرش مع البيانات)
  Widget _buildCreditCardView() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Container(
          width: double.infinity,
          height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF567DF4),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Stack(
          children: [
            // الدائرة الداكنة الخلفية
            Positioned(
              right: -50,
              top: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  color: Color(0xFF192242),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // بيانات البطاقة (CVV, Holder, EXP, Number)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // الصف العلوي (CVV واللوجو)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCardDataColumn('CVV', '985'),
                      // استدعاء الصورة (Logo)
                      Image.asset(
                        'assets/images/credit_card.png', 
                        height: 25,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.credit_card, size: 25, color: Colors.white),
                      ),
                    ],
                  ),
                  // الصف الأوسط (رقم البطاقة المخفي)
                  const Text(
                    '**** ** ** 6478',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                  // الصف السفلي (HOLDER والـ EXP)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCardDataColumn('HOLDER', 'name'),
                      _buildCardDataColumn('EXP', '07/29'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
     ),
    );
  }

  Widget _buildCardDataColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFE2E9FD), fontSize: 12, fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ويدجت المجموع
  Widget _buildTotalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FF),
        border: const Border(left: BorderSide(color: Color(0xFF237D8C), width: 5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('TOTAL', style: TextStyle(color: Color(0xFF677191), fontSize: 16, fontWeight: FontWeight.bold)),
          Text('15 SR', style: TextStyle(color: Color(0xFF237D8C), fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ويدجت زر الدفع السفلي
  Widget _buildBottomPayButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            // هنا الربط بصفحة "تم الدفع بنجاح" أو التذكرة
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF237D8C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            elevation: 4,
            shadowColor: Colors.black45,
          ),
          child: const Text(
            'Pay',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// الهيدر الموحد لضمان التناسق
class _CustomHeader extends StatelessWidget {
  final String title;
  const _CustomHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF195A64), Color(0xFF34B5CA)]),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}