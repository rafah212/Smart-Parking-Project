import 'package:flutter/material.dart';
import 'package:parkliapp/core/widgets/responsive_preview.dart';
import 'parking_timer.dart';

class ParkingTicket extends StatelessWidget {
  const ParkingTicket({super.key});

  // دالة موحدة للانتقال للتايمر عشان ما نكرر الكود
  void _goToTimer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParkingTimerPage()),
    );
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
            // 1. زر (X) في الزاوية يودي للتايمر
            Positioned(
              left: 20,
              top: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => _goToTimer(context),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              child: Column(
                children: [
                  const Text(
                    'Your Parking Ticket',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 30),

                  //  التذكرة
                  _buildTicketCard(),

                  const SizedBox(height: 30),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Please scan the code on the parking when you arrived',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 2. زر الـ Download (بي دي اف )
                  _buildActionButton(
                    context: context,
                    label: 'Download',
                    color: const Color(0xFF2B2C30),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Downloading PDF...')),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // 3. الزر الجديد اللي يودي للتايمر (Track Time)
                  _buildActionButton(
                    context: context,
                    label: 'Go to Timer',
                    color: const Color(0xFF237D8C), 
                    onTap: () => _goToTimer(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت لبناء الأزرار بشكل موحد ومرتب
  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27.5)),
          elevation: 4,
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }


  Widget _buildTicketCard() {
return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 350),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('College of Science & Arts - Lot A', 
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF192342), fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Unaizah 56453', style: TextStyle(color: Color(0xFF237D8C), fontSize: 14)),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: const Color(0xA3E2F7FB),
            child: Column(
              children: [
                _buildInfoRow('VEHICLE', 'CAR', 'HZN | 8421'),
                const SizedBox(height: 20),
                _buildInfoRow('DURATION', '4 hours', '25 Nov. 2025'),
              ],
            ),
          ),
          Row(
            children: [
              _buildHalfCircle(isLeft: true),
              Expanded(child: Container(height: 1, color: Colors.grey.withOpacity(0.3))),
              _buildHalfCircle(isLeft: false),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25),
            decoration: const BoxDecoration(color: Color(0x6BA1D5D9), borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
            child: const Text('Slot A5', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF192242), fontSize: 32, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String val1, String val2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF237D8C), fontSize: 12, fontWeight: FontWeight.bold)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(val1, style: const TextStyle(color: Color(0xFF192242), fontSize: 16, fontWeight: FontWeight.bold)),
          Text('• $val2', style: const TextStyle(color: Color(0xFF192242), fontSize: 16, fontWeight: FontWeight.bold)),
        ]),
      ],
    );
  }

  Widget _buildHalfCircle({required bool isLeft}) {
    return SizedBox(height: 30, width: 15, child: DecoratedBox(decoration: BoxDecoration(
      color: const Color(0xFF2992A3),
      borderRadius: BorderRadius.only(
        topRight: isLeft ? const Radius.circular(30) : Radius.zero,
        bottomRight: isLeft ? const Radius.circular(30) : Radius.zero,
        topLeft: isLeft ? Radius.zero : const Radius.circular(30),
        bottomLeft: isLeft ? Radius.zero : const Radius.circular(30),
      ),
    )));
  }
}