import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/app_session_service.dart';
import 'package:parkliapp/core/services/booking_service.dart';
import 'package:parkliapp/core/services/parking_service.dart';
import 'package:parkliapp/core/services/place_service.dart';
import 'package:parkliapp/core/services/vehicle_service.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/models/parking_spot.dart';
import 'package:parkliapp/features/parking/payment_success.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final PlaceService _placeService = PlaceService();
  final ParkingService _parkingService = ParkingService();
  final VehicleService _vehicleService = VehicleService();
  final BookingService _bookingService = BookingService();
  final AppSessionService _appSessionService = AppSessionService();

  Place? _place;
  ParkingSpot? _spot;
  VehicleData? _vehicle;

  bool _isLoading = true;
  bool _isPaying = false;
  String? _error;

  String _cardNumber = "**** ****";
  String _cardHolder = "";
  String _cardExp = "MM/YY";
  String _cardCVV = "***";
  bool _isCardInfoAdded = false;

  @override
  void initState() {
    super.initState();
    _loadPaymentDetails();
  }

  Future<void> _loadPaymentDetails() async {
    try {
      final session = await _appSessionService.getCurrentSession();

      if (session == null) {
        if (!mounted) return;
        setState(() {
          _error = AppData.translate(
            'You need to log in first',
            'يجب تسجيل الدخول أولاً',
          );
          _isLoading = false;
        });
        return;
      }

      final placeId = AppData.selectedPlaceId;
      final spotId = AppData.selectedSpotId;
      String? vehicleId = AppData.selectedVehicleId;

      if (placeId == null || spotId == null) {
        if (!mounted) return;
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

      if (vehicleId == null) {
        final vehicles = await _vehicleService.getMyVehicles(session.userId);

        if (vehicles.isNotEmpty) {
          vehicleId = vehicles.first.id;
          AppData.selectedVehicleId = vehicleId;
        }
      }

      final vehicle = vehicleId != null
          ? await _vehicleService.getVehicleById(vehicleId)
          : null;

      if (!mounted) return;

      setState(() {
        _place = place;
        _spot = spot;
        _vehicle = vehicle;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = AppData.translate(
          'Failed to load payment details',
          'فشل تحميل بيانات الدفع',
        );
        _isLoading = false;
      });
    }
  }

  void _showAddCardSheet() {
    final TextEditingController numberController = TextEditingController();
    final TextEditingController holderController = TextEditingController();
    final TextEditingController expController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppData.translate('Enter Card Details', 'أدخل بيانات البطاقة'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF237D8C),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: numberController,
              decoration: InputDecoration(
                labelText: AppData.translate('Card Number', 'رقم البطاقة'),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: holderController,
              decoration: InputDecoration(
                labelText: AppData.translate('Holder Name', 'اسم صاحب البطاقة'),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expController,
                    decoration: InputDecoration(
                      labelText: AppData.translate(
                        'Expiry Date',
                        'تاريخ الانتهاء',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    decoration: const InputDecoration(labelText: 'CVV'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF237D8C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _cardNumber = numberController.text.isEmpty
                        ? _cardNumber
                        : numberController.text;
                    _cardHolder = holderController.text.isEmpty
                        ? _cardHolder
                        : holderController.text;
                    _cardExp = expController.text.isEmpty
                        ? _cardExp
                        : expController.text;
                    _cardCVV = cvvController.text.isEmpty
                        ? _cardCVV
                        : cvvController.text;
                    _isCardInfoAdded = true;
                  });

                  Navigator.pop(context);
                },
                child: Text(
                  AppData.translate('Save', 'حفظ'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  double _calculateTotal() {
    if (_place == null) return 0.0;

    const double price = 3.25;

    final name = _place!.name.toLowerCase();
    final category = _place!.category.toLowerCase();

    final isUniversity = name.contains('university') ||
        name.contains('college') ||
        name.contains('جامعة') ||
        name.contains('كلية') ||
        category.contains('university') ||
        category.contains('college') ||
        category.contains('جامعة') ||
        category.contains('كلية');

    final isHospital = name.contains('hospital') ||
        name.contains('مستشفى') ||
        category.contains('hospital') ||
        category.contains('مستشفى');

    if (isUniversity) {
      return 0.0;
    }

    if (isHospital) {
      return price;
    }

    final hours = AppData.durationHours <= 0 ? 1 : AppData.durationHours;
    final cappedHours = hours > 24 ? 24 : hours;

    return price * cappedHours;
  }

  Future<void> _payNow() async {
    final session = await _appSessionService.getCurrentSession();

    if (session == null) {
      _showSnackBar(
        AppData.translate(
          'You need to log in first',
          'يجب تسجيل الدخول أولاً',
        ),
      );
      return;
    }

    if (_place == null || _spot == null) {
      _showSnackBar(
        AppData.translate(
          'Missing booking details',
          'بيانات الحجز ناقصة',
        ),
      );
      return;
    }

    if (!_isCardInfoAdded) {
      _showSnackBar(
        AppData.translate(
          'Please add card details first',
          'يرجى إضافة بيانات البطاقة أولاً',
        ),
      );
      return;
    }

    setState(() => _isPaying = true);

    try {
      final bookingId = await _bookingService.createBooking(
        userId: session.userId,
        placeId: _place!.id,
        spotId: _spot!.id,
        spotLabel: _spot!.label,
        bookedAt: AppData.selectedDate ?? DateTime.now(),
        startTime: AppData.bookingStartTime,
        endTime: AppData.bookingEndTime,
      );

      AppData.currentBookingId = bookingId;

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentSuccessScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      _showSnackBar(
        AppData.translate(
          'Payment failed',
          'فشل الدفع',
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isPaying = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _calculateTotal();

    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _CustomHeader(
                title: AppData.translate('Payment method', 'طريقة الدفع'),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 30,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppData.translate(
                                    'Select payment method',
                                    'اختر طريقة الدفع',
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF25054D),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _buildPaymentOption('Apple pay'),
                                GestureDetector(
                                  onTap: _showAddCardSheet,
                                  child: _buildPaymentOption(
                                    AppData.translate('CARD', 'بطاقة ائتمان'),
                                  ),
                                ),
                                const SizedBox(height: 28),
                                _buildBookingSummary(),
                                const SizedBox(height: 30),
                                _buildCreditCardView(),
                                const SizedBox(height: 40),
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

  Widget _buildBookingSummary() {
    final placeName =
        _place?.name ?? AppData.translate('Unknown location', 'موقع غير محدد');

    final spotLabel =
        _spot?.label ?? AppData.translate('Unknown slot', 'موقف غير محدد');

    final vehicleText = _vehicle == null
        ? AppData.translate('No vehicle selected', 'لم يتم اختيار مركبة')
        : '${_vehicle!.plateType} • ${_vehicle!.displayPlate}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FCFD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow(
            AppData.translate('Parking Location', 'الموقع'),
            placeName,
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            AppData.translate('Slot', 'الموقف'),
            spotLabel,
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            AppData.translate('Vehicle', 'المركبة'),
            vehicleText,
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            AppData.translate('Duration', 'المدة'),
            '${AppData.durationHours} ${AppData.translate('hours', 'ساعات')}',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF677191),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: Text(
            value,
            textAlign: AppData.isArabic ? TextAlign.left : TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF1A485F),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalCard(double price) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FF),
        border: Border(
          left: AppData.isArabic
              ? BorderSide.none
              : const BorderSide(
                  color: Color(0xFF237D8C),
                  width: 5,
                ),
          right: AppData.isArabic
              ? const BorderSide(
                  color: Color(0xFF237D8C),
                  width: 5,
                )
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppData.translate('TOTAL', 'الإجمالي'),
            style: const TextStyle(
              color: Color(0xFF677191),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${price.toStringAsFixed(2)} ${AppData.translate('SR', 'ريال')}',
            style: const TextStyle(
              color: Color(0xFF237D8C),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

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
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF677191),
              fontSize: 16,
            ),
          ),
          const Icon(
            Icons.add,
            color: Color(0xFF237D8C),
            size: 20,
          ),
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
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
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
                  decoration: const BoxDecoration(
                    color: Color(0xFF192242),
                    shape: BoxShape.circle,
                  ),
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
                        _buildCardDataColumn('CVV', _cardCVV),
                        const Icon(
                          Icons.credit_card,
                          size: 25,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Text(
                      _cardNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCardDataColumn(
                          AppData.translate('HOLDER', 'صاحب البطاقة'),
                          _cardHolder.isEmpty ? "---" : _cardHolder,
                        ),
                        _buildCardDataColumn('EXP', _cardExp),
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
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFE2E9FD),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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
          onPressed:
              (_isLoading || _isPaying || _error != null) ? null : _payNow,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF237D8C),
            disabledBackgroundColor: const Color(0xFFB7D7DC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: _isPaying
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  AppData.translate('Pay', 'ادفع الآن'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
        gradient: LinearGradient(
          colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
        ),
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
                AppData.isArabic
                    ? Icons.arrow_back_ios_new
                    : Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
