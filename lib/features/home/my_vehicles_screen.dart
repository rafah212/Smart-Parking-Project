import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/vehicle_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({super.key});

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  final VehicleService _vehicleService = VehicleService();

  List<VehicleData> myVehicles = [];
  bool isSaudiSelected = true;
  String selectedPlateType = 'Private';
  bool _isLoading = true;
  bool _isAddingVehicle = false;

  final TextEditingController _lettersController = TextEditingController();
  final TextEditingController _numbersController = TextEditingController();
  final TextEditingController _otherPlateController = TextEditingController();

  final List<Map<String, dynamic>> plateTypes = [
    {'name': 'Private', 'ar': 'خصوصي', 'color': Colors.white},
    {'name': 'Public Transport', 'ar': 'نقل عام', 'color': Color(0xFFEAB308)},
    {'name': 'Private Transport', 'ar': 'نقل خاص', 'color': Color(0xFF3B82F6)},
    {'name': 'Public Bus', 'ar': 'حافلة عامة', 'color': Color(0xFFEAB308)},
    {'name': 'Taxi', 'ar': 'أجرة', 'color': Color(0xFFEAB308)},
    {'name': 'Diplomatic', 'ar': 'دبلوماسي', 'color': Color(0xFF22C55E)},
    {'name': 'Motorcycle', 'ar': 'دراجة نارية', 'color': Colors.white},
  ];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  @override
  void dispose() {
    _lettersController.dispose();
    _numbersController.dispose();
    _otherPlateController.dispose();
    super.dispose();
  }

  Future<void> _loadVehicles() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final vehicles = await _vehicleService.getMyVehicles(user.id);

      if (!mounted) return;
      setState(() {
        myVehicles = vehicles;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppData.translate(
              'Failed to load vehicles',
              'فشل تحميل المركبات',
            ),
          ),
        ),
      );
    }
  }

  Future<void> _addNewVehicle() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    if (isSaudiSelected) {
      if (_lettersController.text.trim().isEmpty ||
          _numbersController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppData.translate(
                'Please enter plate letters and numbers',
                'يرجى إدخال حروف وأرقام اللوحة',
              ),
            ),
          ),
        );
        return;
      }
    } else {
      if (_otherPlateController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppData.translate(
                'Please enter plate information',
                'يرجى إدخال بيانات اللوحة',
              ),
            ),
          ),
        );
        return;
      }
    }

    setState(() {
      _isAddingVehicle = true;
    });

    try {
      if (isSaudiSelected) {
        await _vehicleService.addVehicle(
          userId: user.id,
          isSaudi: true,
          plateType: selectedPlateType,
          country: AppData.translate('Saudi Arabia', 'المملكة العربية السعودية'),
          plateLetters: _lettersController.text.trim(),
          plateNumbers: _numbersController.text.trim(),
        );
      } else {
        await _vehicleService.addVehicle(
          userId: user.id,
          isSaudi: false,
          plateType: AppData.translate('Other', 'أخرى'),
          country: AppData.translate('International', 'دولي'),
          plateText: _otherPlateController.text.trim(),
        );
      }

      _lettersController.clear();
      _numbersController.clear();
      _otherPlateController.clear();

      if (mounted) {
        Navigator.pop(context);
      }

      await _loadVehicles();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppData.translate(
              'Failed to add vehicle',
              'فشل في إضافة المركبة',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAddingVehicle = false;
        });
      }
    }
  }

  Future<void> _deleteVehicle(String vehicleId) async {
    try {
      if (AppData.selectedVehicleId == vehicleId) {
        AppData.selectedVehicleId = null;
      }

      await _vehicleService.deleteVehicle(vehicleId);
      await _loadVehicles();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppData.translate(
              'Failed to delete vehicle',
              'فشل حذف المركبة',
            ),
          ),
        ),
      );
    }
  }

  void _selectVehicle(VehicleData vehicle) {
    AppData.selectedVehicleId = vehicle.id;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppData.translate(
            'Vehicle selected successfully',
            'تم اختيار المركبة بنجاح',
          ),
        ),
      ),
    );

    Navigator.pop(context);
  }

  void _showNafathVerification(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0A0A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'نفاذ',
                  style: TextStyle(
                    color: Color(0xFF237D8C),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'التحقق من خلال تطبيق نفاذ، الرجاء إدخال رقم الهوية الخاص بك',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 30),
                TextField(
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '* أدخل رقم الهوية',
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF237D8C).withOpacity(0.6),
                    ),
                    child: const Text(
                      'التالي',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isSelectedVehicle(VehicleData vehicle) {
    return AppData.selectedVehicleId == vehicle.id;
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
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF414141),
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppData.translate('My Vehicles', 'مركباتي'),
            style: const TextStyle(
              color: Color(0xFF2A2A2A),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF237D8C),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    if (myVehicles.isEmpty) ...[
                      const SizedBox(height: 30),
                      Center(
                        child: Container(
                          width: 180,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0x1A237D8C),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.directions_car_filled_rounded,
                            size: 100,
                            color: Color(0xFF237D8C),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        AppData.translate('No vehicles found', 'لا توجد مركبات'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A485F),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppData.translate(
                          'Add a vehicle manually or verify your account to retrieve your registered vehicles automatically.',
                          'أضف مركبة يدوياً أو وثق حسابك لسحب بيانات مركباتك المسجلة تلقائياً.',
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF898989),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildVerifyCard(),
                    ] else ...[
                      Expanded(
                        child: ListView.builder(
                          itemCount: myVehicles.length,
                          itemBuilder: (context, index) =>
                              _buildVehicleListItem(myVehicles[index]),
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (myVehicles.isEmpty)
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () => _showNafathVerification(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF237D8C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppData.translate('Verify Account', 'توثيق الحساب'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => _showAddVehicleSheet(context),
                      child: Text(
                        myVehicles.isEmpty
                            ? AppData.translate(
                                'Add Vehicle Manually',
                                'إضافة مركبة يدوياً',
                              )
                            : AppData.translate(
                                '+ Add Another Vehicle',
                                '+ إضافة مركبة أخرى',
                              ),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildVerifyCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FBFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF237D8C).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: Color(0xFF237D8C),
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                AppData.translate(
                  'Why verify your account?',
                  'لماذا توثق حسابك؟',
                ),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A485F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBenefitItem(
            AppData.translate(
              'Retrieve vehicle data automatically.',
              'استرجاع بيانات المركبات تلقائياً.',
            ),
          ),
          _buildBenefitItem(
            AppData.translate(
              'Required for residential permits.',
              'مطلب أساسي لتصاريح السكن.',
            ),
          ),
          _buildBenefitItem(
            AppData.translate(
              'Ensures accuracy of vehicle data.',
              'ضمان دقة بيانات المركبة.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 2,
            backgroundColor: Color(0xFF237D8C),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF5A5A5A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleListItem(VehicleData vehicle) {
    final isSelected = _isSelectedVehicle(vehicle);

    return GestureDetector(
      onTap: () => _selectVehicle(vehicle),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF5FBFC)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF237D8C)
                : const Color(0xFFEEEEEE),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.directions_car_filled,
              color: Color(0xFF237D8C),
              size: 30,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.displayPlate,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1A485F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vehicle.plateType} - ${vehicle.country}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFF237D8C),
                ),
              ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
              ),
              onPressed: () => _deleteVehicle(vehicle.id),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddVehicleSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Directionality(
              textDirection:
                  AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF121212),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppData.translate(
                                  'Add Vehicle Information',
                                  'إضافة معلومات المركبة',
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 25),
                              Container(
                                height: 50,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    _buildTabButton(
                                      AppData.translate(
                                        'Saudi Arabia',
                                        'السعودية',
                                      ),
                                      isSaudiSelected,
                                      () => setSheetState(
                                        () => isSaudiSelected = true,
                                      ),
                                    ),
                                    _buildTabButton(
                                      AppData.translate('Other', 'أخرى'),
                                      !isSaudiSelected,
                                      () => setSheetState(
                                        () => isSaudiSelected = false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              isSaudiSelected
                                  ? _buildSaudiForm(setSheetState)
                                  : _buildOtherForm(),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isAddingVehicle ? null : _addNewVehicle,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF237D8C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isAddingVehicle
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    AppData.translate(
                                      'Add Vehicle',
                                      'إضافة المركبة',
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
      },
    );
  }

  Widget _buildSaudiForm(StateSetter setSheetState) {
    final Color plateColor =
        plateTypes.firstWhere((e) => e['name'] == selectedPlateType)['color'];
    final String plateAr =
        plateTypes.firstWhere((e) => e['name'] == selectedPlateType)['ar'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppData.translate('Plate Type*', 'نوع اللوحة*'),
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPlateTypePicker(context, setSheetState),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                const Spacer(),
                Text(
                  AppData.translate(selectedPlateType, plateAr),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 10),
                _buildSmallPlateIcon(plateColor),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        _buildPlateDesign(plateColor),
        const SizedBox(height: 30),
        _buildInputField(
          AppData.translate('Plate Letters*', 'حروف اللوحة*'),
          'أ ب ج',
          _lettersController,
        ),
        const SizedBox(height: 15),
        _buildInputField(
          AppData.translate('Plate Numbers*', 'أرقام اللوحة*'),
          '١ ٢ ٣ ٤',
          _numbersController,
        ),
      ],
    );
  }

  Widget _buildPlateDesign(Color plateColor) {
    return Center(
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF757575),
            width: 2,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (!AppData.isArabic) ...[
                const Expanded(
                  child: Center(
                    child: Text(
                      'A B C',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  color: Color(0xFF757575),
                  thickness: 2,
                  width: 2,
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      '1 2 3 4',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  color: Color(0xFF757575),
                  thickness: 2,
                  width: 2,
                ),
                Container(
                  width: 40,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: plateColor,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🇸🇦', style: TextStyle(fontSize: 14)),
                      Text(
                        'K\nS\nA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  width: 40,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: plateColor,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🇸🇦', style: TextStyle(fontSize: 14)),
                      Text(
                        'K\nS\nA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  color: Color(0xFF757575),
                  thickness: 2,
                  width: 2,
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      '١ ٢ ٣ ٤',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  color: Color(0xFF757575),
                  thickness: 2,
                  width: 2,
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'أ ب ج',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showPlateTypePicker(BuildContext context, StateSetter parentSetState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      builder: (context) => ListView.builder(
        shrinkWrap: true,
        itemCount: plateTypes.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            AppData.translate(
              plateTypes[index]['name'],
              plateTypes[index]['ar'],
            ),
            style: const TextStyle(color: Colors.white),
          ),
          trailing: _buildSmallPlateIcon(plateTypes[index]['color']),
          onTap: () {
            parentSetState(() => selectedPlateType = plateTypes[index]['name']);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildSmallPlateIcon(Color color) {
    return Container(
      width: 35,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0x1F000000)),
      ),
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          const VerticalDivider(color: Color(0x1F000000), width: 1),
          const Expanded(child: SizedBox()),
          Container(width: 8, color: color),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppData.translate('Plate Information*', 'معلومات اللوحة*'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
        _buildInputField(
          AppData.translate('Plate Information*', 'بيانات اللوحة*'),
          AppData.translate('Enter plate number', 'أدخل رقم اللوحة'),
          _otherPlateController,
        ),
      ],
    );
  }

  Widget _buildTabButton(
    String title,
    bool isActive,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF237D8C) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white60,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}