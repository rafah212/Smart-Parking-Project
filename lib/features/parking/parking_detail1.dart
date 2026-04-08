import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/place_service.dart';
import 'package:parkliapp/core/services/parking_service.dart';
import 'package:parkliapp/core/services/vehicle_service.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/models/parking_spot.dart';
import 'package:parkliapp/features/parking/parking_detail2.dart';
import 'package:parkliapp/features/parking/payment_method.dart';

class ParkingDetail1 extends StatefulWidget {
  const ParkingDetail1({super.key});

  @override
  State<ParkingDetail1> createState() => _ParkingDetail1State();
}

class _ParkingDetail1State extends State<ParkingDetail1> {
  final PlaceService _placeService = PlaceService();
  final ParkingService _parkingService = ParkingService();
  final VehicleService _vehicleService = VehicleService();

  double _currentValue = AppData.durationHours.toDouble();

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
      final vehicleId = AppData.selectedVehicleId;

      if (placeId == null || spotId == null) {
        setState(() {
          _error = AppData.translate(
            'Booking information is incomplete',
            'بيانات الحجز غير مكتملة',
          );
          _isLoading = false;
        });
        return;
      }

      final place = await _placeService.getPlaceById(placeId);
      final spot = await _parkingService.getSpotById(spotId);
      final vehicle =
          vehicleId != null ? await _vehicleService.getVehicleById(vehicleId) : null;

      if (!mounted) return;

      setState(() {
        _place = place;
        _spot = spot;
        _vehicle = vehicle;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = AppData.translate(
          'Failed to load booking details',
          'فشل تحميل تفاصيل الحجز',
        );
        _isLoading = false;
      });
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
              _ParkingHeader(
                title: AppData.translate('Parking detail', 'تفاصيل الموقف'),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF237D8C),
                        ),
                      )
                    : _error != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.asset(
                                    'assets/images/parkdetial.png',
                                    height: 220,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  AppData.translate('Time Duration', 'مدة الوقوف'),
                                  style: const TextStyle(
                                    color: Color(0xFF237D8C),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _buildTimeSlider(),
                                const SizedBox(height: 30),
                                _buildParkingInfoCard(),
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

  Widget _buildTimeSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatTime(_currentValue),
              style: const TextStyle(
                color: Color(0xFF195A64),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppData.translate('24 h', '٢٤ ساعة'),
              style: const TextStyle(color: Color(0xFF195A64)),
            ),
          ],
        ),
        Slider(
          value: _currentValue,
          min: 1.0,
          max: 24.0,
          divisions: 23,
          activeColor: const Color(0xFF237D8C),
          inactiveColor: const Color(0xFFE5E5E5),
          onChanged: (value) {
            setState(() {
              _currentValue = value;
              AppData.durationHours = value.toInt();
            });
          },
        ),
      ],
    );
  }

  Widget _buildParkingInfoCard() {
    final vehicleType = _vehicle?.plateType.isNotEmpty == true
        ? _vehicle!.plateType
        : AppData.translate('No vehicle selected', 'لم يتم اختيار مركبة');

    final vehiclePlate = _vehicle != null
        ? _vehicle!.displayPlate
        : AppData.translate('No plate selected', 'لم يتم اختيار لوحة');

    final placeName = _place?.name.isNotEmpty == true
        ? _place!.name
        : AppData.translate('Unknown location', 'موقع غير محدد');

    final spotLabel = _spot != null
        ? '${AppData.translate('Slot', 'موقف')} ${_spot!.label}'
        : AppData.translate('No slot selected', 'لم يتم اختيار موقف');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F0F2).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE8ECEE)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRowInfo(
                  AppData.translate('VEHICLE TYPE', 'نوع المركبة'),
                  vehicleType,
                  vehiclePlate,
                ),
                const SizedBox(height: 20),
                _buildRowInfo(
                  AppData.translate('PARKING LOT', 'موقع الموقف'),
                  placeName,
                  spotLabel,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color(0xFFC3E6EC),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppData.translate('TOTAL', 'الإجمالي'),
                  style: const TextStyle(
                    color: Color(0xFF237D8C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _place?.priceLabel ?? AppData.translate('FREE', 'مجاني'),
                  style: const TextStyle(
                    color: Color(0xFF237D8C),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowInfo(String label, String val1, String val2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFA3237D8C),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                val1,
                style: const TextStyle(
                  color: Color(0xFF192242),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '• $val2',
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Color(0xFF192242),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomActionArea() {
    final canContinue = !_isLoading && _error == null && _place != null && _spot != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x12000000),
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: !canContinue
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParkingDetail2(),
                      ),
                    ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: canContinue
                    ? const Color(0xFFC3E6EC)
                    : const Color(0xFFE0E0E0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_month_outlined,
                color: canContinue
                    ? const Color(0xFF237D8C)
                    : const Color(0xFF9E9E9E),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: !canContinue
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentMethodScreen(),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF237D8C),
                  disabledBackgroundColor: const Color(0xFFB7D7DC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppData.translate('Confirm & Pay', 'تأكيد ودفع'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(double value) {
    final hours = value.toInt();

    if (AppData.isArabic) {
      if (hours == 1) return 'ساعة واحدة';
      if (hours == 2) return 'ساعتين';
      if (hours >= 3 && hours <= 10) return '$hours ساعات';
      return '$hours ساعة';
    }

    return '$hours ${hours == 1 ? 'hour' : 'hours'}';
  }
}

class _ParkingHeader extends StatelessWidget {
  final String title;

  const _ParkingHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: AppData.isArabic ? null : 12,
            right: AppData.isArabic ? 12 : null,
            top: 22,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}