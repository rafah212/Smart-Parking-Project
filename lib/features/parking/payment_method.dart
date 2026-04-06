import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; 
import 'payment_success.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  // --- دالة حساب السعر الذكية ---
  double _calculateTotal() {
    double pricePerHour = 3.25;
    
    // إذا كان الموقف مستشفى أو جهة حكومية (حسب اختيار المستخدم للموقع)
    bool isGovernment = AppData.selectedLocation.contains('Hospital') || 
                        AppData.selectedLocation.contains('University') ||
                        AppData.selectedLocation.contains('مستشفى') ||
                        AppData.selectedLocation.contains('جامعة');

    if (isGovernment) {
      return pricePerHour; // سعر ثابت مهما كانت الساعات
    } else {
      return pricePerHour * AppData.durationHours; // سعر الساعة * عدد الساعات
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = _calculateTotal();

    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _CustomHeader(title: AppData.translate('Payment method', 'طريقة الدفع')),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppData.translate('Select payment method', 'اختر طريقة الدفع'),
                        style: const TextStyle(color: Color(0xFF25054D), fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 24),

                      _buildPaymentOption('Apple pay'),
                      _buildPaymentOption('Stc pay'),
                      _buildPaymentOption(AppData.translate('CARD', 'بطاقة ائتمان')),

                      const SizedBox(height: 40),
                      _buildCreditCardView(),
                      const SizedBox(height: 40),

                      // --- عرض المجموع المحسوب تلقائياً ---
                      _buildTotalCard(totalPrice),
                    ],
                  ),
                ),
              ),

              _buildBottomPayButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- ويدجت المجموع بتنسيق السعر الجديد ---
  Widget _buildTotalCard(double price) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FF),
        border: Border(
          left: AppData.isArabic ? BorderSide.none : const BorderSide(color: Color(0xFF237D8C), width: 5),
          right: AppData.isArabic ? const BorderSide(color: Color(0xFF237D8C), width: 5) : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppData.translate('TOTAL', 'الإجمالي'), 
            style: const TextStyle(color: Color(0xFF677191), fontSize: 16, fontWeight: FontWeight.bold)
          ),
          Text(
            '${price.toStringAsFixed(2)} ${AppData.translate('SR', 'ريال')}', 
            style: const TextStyle(color: Color(0xFF237D8C), fontSize: 22, fontWeight: FontWeight.bold)
          ),
        ],
      ),
    );
  }

  // (باقي الويدجت مثل _buildPaymentOption و _buildCreditCardView تبقى كما هي في الكود السابق)
  
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
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: AppData.isArabic ? null : -50,
                left: AppData.isArabic ? -50 : null,
                top: -80,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: const BoxDecoration(color: Color(0xFF192242), shape: BoxShape.circle),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCardDataColumn('CVV', '985'),
                        Image.asset(
                          'assets/images/credit_card.png', 
                          height: 25,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.credit_card, size: 25, color: Colors.white),
                        ),
                      ],
                    ),
                    const Text(
                      '**** 6478',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCardDataColumn(AppData.translate('HOLDER', 'صاحب البطاقة'), 'Rafah Aljabri'),
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

  Widget _buildBottomPayButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF237D8C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            elevation: 0,
          ),
          child: Text(
            AppData.translate('Pay', 'ادفع الآن'),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

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
            left: AppData.isArabic ? null : 10,
            right: AppData.isArabic ? 10 : null,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: Icon(
                AppData.isArabic ? Icons.arrow_back_ios_new : Icons.arrow_back_ios, 
                color: Colors.white, size: 20
              ),
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