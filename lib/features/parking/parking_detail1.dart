import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/place_service.dart';
import 'package:parkliapp/core/services/parking_service.dart';
import 'package:parkliapp/core/services/vehicle_service.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/models/parking_spot.dart';
import 'package:parkliapp/features/parking/payment_method.dart';
import 'package:parkliapp/features/parking/parking_detail2.dart';

class ParkingDetail1 extends StatefulWidget {
  const ParkingDetail1({super.key});

  @override
  State<ParkingDetail1> createState() => _ParkingDetail1State();
}

class _ParkingDetail1State extends State<ParkingDetail1> {
  final PlaceService _placeService = PlaceService();
  final ParkingService _parkingService = ParkingService();
  final VehicleService _vehicleService = VehicleService();

  double _currentValue = AppData.durationHours < 1 ? 1.0 : AppData.durationHours.toDouble();

  Place? _place;
  ParkingSpot? _spot;
  VehicleData? _vehicle;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBookingDetails();
  }

  Future<void> _loadBookingDetails() async {
    try {
      final placeId = AppData.selectedPlaceId;
      final spotId = AppData.selectedSpotId;
      if (placeId == null || spotId == null) {
        setState(() {
          _error = AppData.translate('Incomplete information', 'بيانات غير مكتملة');
          _isLoading = false;
        });
        return;
      }
      final place = await _placeService.getPlaceById(placeId);
      final spot = await _parkingService.getSpotById(spotId);
      final vehicle = AppData.selectedVehicleId != null ? await _vehicleService.getVehicleById(AppData.selectedVehicleId!) : null;

      if (!mounted) return;
      setState(() {
        _place = place; _spot = spot; _vehicle = vehicle; _isLoading = false;
      });
    } catch (e) {
      setState(() { _error = AppData.translate('Error loading', 'خطأ في التحميل'); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBFB),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(AppData.translate('Parking detail', 'تفاصيل الموقف')),
              Expanded(
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF237D8C)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Image.asset('assets/images/parkdetial.png', height: 220),
                          const SizedBox(height: 30),
                          _buildTimeSlider(),
                          const SizedBox(height: 30),
                          _buildInfoCard(),
                        ],
                      ),
                    ),
              ),
              _buildBottomActionArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF195A64), Color(0xFF34B5CA)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: AppData.isArabic ? null : 12,
            right: AppData.isArabic ? 12 : null,
            top: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTimeSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${_currentValue.toInt()} ${AppData.translate('Hours', 'ساعة')}", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(AppData.translate('24 h', '٢٤ ساعة')),
          ],
        ),
        Slider(
          value: _currentValue, min: 1.0, max: 24.0, divisions: 23,
          activeColor: const Color(0xFF237D8C),
          onChanged: (v) => setState(() { _currentValue = v; AppData.durationHours = v.toInt(); }),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFE3F0F2), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          _rowInfo(AppData.translate('VEHICLE', 'المركبة'), _vehicle?.displayPlate ?? '---'),
          const Divider(),
          _rowInfo(AppData.translate('LOCATION', 'الموقع'), _place?.name ?? '---'),
          const Divider(),
          _rowInfo(AppData.translate('TOTAL', 'الإجمالي'), _place?.priceLabel ?? 'FREE'),
        ],
      ),
    );
  }

  Widget _rowInfo(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            val,
            textAlign: AppData.isArabic ? TextAlign.left : TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold),
            softWrap: true,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)]),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ParkingDetail2())),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Color(0xFFC3E6EC), shape: BoxShape.circle),
              child: const Icon(Icons.calendar_month_outlined, color: Color(0xFF237D8C)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // 1. تحديد وقت البداية: إذا لم يتم اختياره من التقويم، نستخدم الوقت الحالي
                DateTime start = AppData.bookingStartTime ?? DateTime.now();
                
                // 2. حساب وقت النهاية: البداية + الساعات المحددة بالسلايدر
                DateTime end = start.add(Duration(hours: AppData.durationHours));

                // 3. تخزين القيم في AppData بشكل نهائي لإرسالها في صفحة الدفع
                AppData.bookingStartTime = start;
                AppData.bookingEndTime = end;

                // 4. الانتقال لصفحة الدفع
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF237D8C),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: Text(AppData.translate('Confirm & Pay', 'تأكيد ودفع'), style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}