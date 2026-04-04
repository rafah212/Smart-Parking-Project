import 'package:flutter/material.dart';
import 'package:parkliapp/core/widgets/responsive_preview.dart';
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
    // --- المؤقت: ينتظر 3 ثواني ثم ينقل المستخدم للتذكرة ---
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
    return ResponsivePreview(
      child: Container(
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
            // زر (X) - الآن ينقل للتذكرة مباشرة إذا لم يرد المستخدم الانتظار
            Positioned(
              left: 20,
              top: 20,
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

                  const Text(
                    'Payment\nSuccess!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 80),

                  const Text(
                    '1 parking slot\nhas been booked for you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE2E9FD),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.7,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  // مؤشر تحميل صغير ليوضح للمستخدم أن التذكرة يتم إصدارها
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
    );
  }
}