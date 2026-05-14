import 'dart:io';
import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/booking_service.dart';
import 'package:parkliapp/core/services/parking_service.dart';
import 'package:parkliapp/core/services/vehicle_service.dart';
import 'package:parkliapp/features/home/models/parking_spot.dart';
import 'parking_timer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ParkingTicket extends StatefulWidget {
  const ParkingTicket({super.key});

  @override
  State<ParkingTicket> createState() => _ParkingTicketState();
}

class _ParkingTicketState extends State<ParkingTicket> {
  final BookingService _bookingService = BookingService();
  final VehicleService _vehicleService = VehicleService();
  final ParkingService _parkingService = ParkingService();

  Map<String, dynamic>? _booking;
  VehicleData? _vehicle;
  ParkingSpot? _spot;

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTicketData();
  }

  Future<void> _downloadPDF() async {
    final pdf = pw.Document();
    
    final places = _booking?['places'] as Map<String, dynamic>?;
    final placeName = (places?['name'] ?? 'Unknown location') as String;
    final slotLabel = _booking?['spot_label'] as String? ?? _spot?.label ?? 'Unknown';
    final vehicleInfo = '${_vehicle?.plateType ?? ""} - ${_vehicle?.displayPlate ?? ""}';
    final bookingId = AppData.currentBookingId ?? "No-ID";
    
    // التعديل هنا:  الوقت والتاريخ  AppData للـ PDF
    final timeStr = AppData.selectedTime ?? "--:--";
    final dateStr = _getFormattedDate();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text("PARKLI TICKET", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Divider(thickness: 2),
                pw.SizedBox(height: 20),
                pw.Text("Location: $placeName", style: pw.TextStyle(fontSize: 16)),
                pw.Text("Slot: $slotLabel", style: pw.TextStyle(fontSize: 16)),
                pw.Text("Vehicle: $vehicleInfo"),
                pw.Text("Duration: ${AppData.durationHours} Hours"),
                pw.Text("Date: $dateStr"),
                pw.Text("Arrival Time: $timeStr"),
                pw.SizedBox(height: 30),
                pw.Text("Scan to Verify", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: 'BookingID: $bookingId | Slot: $slotLabel | Time: $timeStr | Date: $dateStr',
                  width: 120,
                  height: 120,
                ),
                pw.SizedBox(height: 30),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text("Thank you for using Parkli App", style: pw.TextStyle(color: PdfColors.grey)),
              ],
            ),
          );
        },
      ),
    );

    try {
      await Printing.sharePdf(
        bytes: await pdf.save(), 
        filename: 'Parkli_Ticket_$bookingId.pdf'
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error downloading file')),
      );
    }
  }

  Future<void> _loadTicketData() async {
    try {
      final bookingId = AppData.currentBookingId;

      if (bookingId == null) {
        setState(() {
          _error = AppData.translate('No booking found', 'لا يوجد حجز حالي');
          _isLoading = false;
        });
        return;
      }

      final booking = await _bookingService.getBookingById(bookingId);

      if (booking == null) {
        setState(() {
          _error = AppData.
        translate('Booking data not found', 'لم يتم العثور على بيانات الحجز');
          _isLoading = false;
        });
        return;
      }

      final vehicleId = AppData.selectedVehicleId;
      final spotId = booking['spot_id'] as String?;

      final vehicle = vehicleId != null ? await _vehicleService.getVehicleById(vehicleId) : null;
      final spot = spotId != null ? await _parkingService.getSpotById(spotId) : null;

      if (!mounted) return;

      setState(() {
        _booking = booking;
        _vehicle = vehicle;
        _spot = spot;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppData.translate('Failed to load ticket data', 'فشل تحميل بيانات التذكرة');
        _isLoading = false;
      });
    }
  }

  void _goToTimer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParkingTimerPage()),
    );
  }

  String _getFormattedDate() {
    final date = AppData.selectedDate;
    const monthsEn = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const monthsAr = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    final month = AppData.translate(monthsEn[date.month - 1], monthsAr[date.month - 1]);
    return "${date.day} $month ${date.year}";
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : _error != null
                  ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))))
                  : Stack(
                      children: [
                        Positioned(
                          left: AppData.isArabic ? null : 20,
                          right: AppData.isArabic ? 20 : null,
                          top: 40,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 30),
                            onPressed: () => _goToTimer(context),
                          ),
                        ),
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
                          child: Column(
                            children: [
                              Text(AppData.translate('Your Parking Ticket', 'تذكرة الموقف الخاصة بك'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 30),
                              _buildTicketCard(),
                              const SizedBox(height: 30),
                              Text(AppData.translate('Please scan the code on the parking when you arrived', 'يرجى مسح الرمز الموجود عند الموقف عند وصولك'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5)),
                              const SizedBox(height: 40),
                              _buildActionButton(
                                context: context,
                                label: AppData.translate('Download', 'تحميل التذكرة'),
                                color: const Color(0xFF2B2C30),
                                onTap: _downloadPDF,
                              ),
                               const SizedBox(height: 15),
                              _buildActionButton(
                                context: context,
                                label: AppData.translate('Go to Timer', 'الذهاب للمؤقت'),
                                color: const Color(0xFF237D8C),
                                onTap: () => _goToTimer(context),
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

  Widget _buildTicketCard() {
    final places = _booking?['places'] as Map<String, dynamic>?;
    final placeName = (places?['name'] ?? AppData.translate('Unknown location', 'موقع غير محدد')) as String;
    final vehicleType = _vehicle?.plateType ?? AppData.translate('No vehicle selected', 'لم يتم اختيار مركبة');
    final vehiclePlate = _vehicle?.displayPlate ?? AppData.translate('No plate selected', 'لم يتم اختيار لوحة');
    final slotLabel = _booking?['spot_label'] as String? ?? _spot?.label ?? AppData.translate('Unknown', 'غير محدد');
    
    // التعديل هنا:  الوقت والتاريخ لواجهة المستخدم (الكارد)
    final timeStr = AppData.selectedTime ?? "--:--";
    final dateStr = _getFormattedDate();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(placeName, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF192342), fontSize: 18, fontWeight: FontWeight.bold)),
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
                _buildInfoRow(AppData.translate('VEHICLE', 'المركبة'), vehicleType, vehiclePlate),
                const SizedBox(height: 20),
                // التعديل هنا: عرض الوقت والتاريخ  في سطر واحد
                _buildInfoRow(AppData.translate('TIME & DATE', 'الوقت والتاريخ'), timeStr, dateStr),
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
            child: Text('${AppData.translate('Slot', 'موقف')} $slotLabel', textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF192242), fontSize: 32, fontWeight: FontWeight.w900)),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(val1, style: const TextStyle(color: Color(0xFF192242), fontSize: 16, fontWeight: FontWeight.bold))),
            const SizedBox(width: 12),
            Expanded(child: Text('• $val2', textAlign: TextAlign.end, style: const TextStyle(color: Color(0xFF192242), fontSize: 16, fontWeight: FontWeight.bold))),
          ],
        ),
      ],
    );
  }

  Widget _buildHalfCircle({required bool isLeft}) {
    final shouldReverse = AppData.isArabic;
    final effectiveLeft = shouldReverse ? !isLeft : isLeft;
    return SizedBox(
      height: 30,
      width: 15,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF2992A3),
          borderRadius: BorderRadius.only(
            topRight: effectiveLeft ? const Radius.circular(30) : Radius.zero,
            bottomRight: effectiveLeft ? const Radius.circular(30) : Radius.zero,
            topLeft: effectiveLeft ? Radius.zero : const Radius.circular(30),
            bottomLeft: effectiveLeft ? Radius.zero : const Radius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({required BuildContext context, required String label, required Color color, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27.5)), elevation: 0),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}