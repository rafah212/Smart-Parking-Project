import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ
import 'parking_ticket.dart'; 

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    // المؤقت: ينتظر 3 ثواني ثم ينقل المستخدم للتذكرة تلقائياً
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ParkingTicket()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
            ),
          ),
          child: Stack(
            children: [
              // زر الإغلاق (X) ينقل للتذكرة فوراً
              Positioned(
                left: AppData.isArabic ? null : 20,
                right: AppData.isArabic ? 20 : null,
                top: 40,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ParkingTicket()),
                    );
                  },
                ),
              ),
              
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // صورة النجاح
                    Image.asset(
                      'assets/images/success.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.check_circle, size: 150, color: Color(0xFF76D75C)),
                    ),
                    
                    const SizedBox(height: 60),

                    Text(
                      AppData.translate('Payment\nSuccess!', 'تم الدفع\nبنجاح!'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    
                    const SizedBox(height: 80),

                    Text(
                      AppData.translate(
                        '1 parking slot\nhas been booked for you.',
                        'تم حجز موقف سيارة واحد\nباسمك الآن.'
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFE2E9FD),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.7,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // مؤشر تحميل بسيط يوضح قرب ظهور التذكرة
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white70,
                      ),
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
}