import 'package:flutter/material.dart';

class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({super.key});

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  List<Map<String, String>> myVehicles = [];
  bool isSaudiSelected = true;
  String selectedPlateType = 'Private';
  
  final TextEditingController _lettersController = TextEditingController();
  final TextEditingController _numbersController = TextEditingController();
  final TextEditingController _otherPlateController = TextEditingController();

  final List<Map<String, dynamic>> plateTypes = [
    {'name': 'Private', 'color': Colors.white},
    {'name': 'Public Transport', 'color': const Color(0xFFEAB308)},
    {'name': 'Private Transport', 'color': const Color(0xFF3B82F6)},
    {'name': 'Public Bus', 'color': const Color(0xFFEAB308)},
    {'name': 'Private Bus', 'color': const Color(0xFF3B82F6)},
    {'name': 'Taxi', 'color': const Color(0xFFEAB308)},
    {'name': 'Diplomatic', 'color': const Color(0xFF22C55E)},
    {'name': 'Motorcycle', 'color': Colors.white},
  ];

  void _addNewVehicle() {
    setState(() {
      if (isSaudiSelected) {
        if (_lettersController.text.isNotEmpty && _numbersController.text.isNotEmpty) {
          myVehicles.add({
            'plate': '${_lettersController.text} | ${_numbersController.text}',
            'type': selectedPlateType,
            'country': 'Saudi Arabia'
          });
        }
      } else {
        if (_otherPlateController.text.isNotEmpty) {
          myVehicles.add({
            'plate': _otherPlateController.text,
            'type': 'Other',
            'country': 'International'
          });
        }
      }
    });
    _lettersController.clear();
    _numbersController.clear();
    _otherPlateController.clear();
    Navigator.pop(context);
  }

  // --- نافذة توثيق نفاذ الجديدة ---
  void _showNafathVerification(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0A0A), // خلفية سوداء كما في الصورة
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20, left: 20, right: 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              // شعار نفاذ
              const Text(
                'نفاذ',
                style: TextStyle(color: Color(0xFF237D8C), fontSize: 48, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 10),
              const Text(
                'التحقق من خلال تطبيق نفاذ الرجاء إدخال رقم الهوية الخاص بك',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 30),
              // حقل رقم الهوية
              TextField(
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '* أدخل رقم الهوية',
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)),
                ),
              ),
              const SizedBox(height: 40),
              // زر التالي
              SizedBox(
                width: double.infinity, height: 54,child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF237D8C).withOpacity(0.6), // لون الزر الباهت كما في الصورة
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('التالي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF414141), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Vehicles', style: TextStyle(color: Color(0xFF2A2A2A), fontSize: 18, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (myVehicles.isEmpty) ...[
              const SizedBox(height: 30),
              Center(
                child: Container(
                  width: 180, height: 120,
                  decoration: BoxDecoration(color: const Color(0x1A237D8C), borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.directions_car_filled_rounded, size: 100, color: Color(0xFF237D8C)),
                ),
              ),
              const SizedBox(height: 30),
              const Text('No vehicles found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A485F))),
              const SizedBox(height: 10),
              const Text('Add a vehicle manually or verify your account to retrieve your registered vehicles automatically.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Color(0xFF898989), height: 1.5)),
              const SizedBox(height: 40),
              _buildVerifyCard(),
            ] else ...[
              Expanded(
                child: ListView.builder(
                  itemCount: myVehicles.length,
                  itemBuilder: (context, index) => _buildVehicleListItem(index),
                ),
              ),
            ],
            const Spacer(),
            if (myVehicles.isEmpty)
              SizedBox(
                width: double.infinity, height: 54,
                child: ElevatedButton(
                  onPressed: () => _showNafathVerification(context), // هنا نفتح نافذة نفاذ
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF237D8C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Verify Account', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _showAddVehicleSheet(context),
              child: Text(myVehicles.isEmpty ? 'Add Vehicle Manually' : '+ Add Another Vehicle', style: const TextStyle(color: Color(0xFF237D8C), fontSize: 15, decoration: TextDecoration.underline)),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // الدوال المساعدة (Verify Card, List Item, etc.)
  Widget _buildVerifyCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFFF5FBFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF237D8C).withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.verified_user_outlined, color: Color(0xFF237D8C), size: 20),
            SizedBox(width: 10),
            Text('Why verify your account?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A485F))),
          ]),
          const SizedBox(height: 12),
          _buildBenefitItem('Retrieve vehicle data automatically.'),
          _buildBenefitItem('Required for residential permits.'),
          _buildBenefitItem('Ensures accuracy of vehicle data.'),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(children: [
        const CircleAvatar(radius: 2, backgroundColor: Color(0xFF237D8C)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF5A5A5A))),
      ]),
    );
  }

  Widget _buildVehicleListItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFEEEEEE)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Row(
        children: [
          const Icon(Icons.directions_car_filled, color: Color(0xFF237D8C), size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(myVehicles[index]['plate']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A485F))),
              Text('${myVehicles[index]['type']} - ${myVehicles[index]['country']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => setState(() => myVehicles.removeAt(index)))
        ],
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
            return Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: const BoxDecoration(color: Color(0xFF121212), borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Add Vehicle Information', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 25),
                            Container(
                              height: 50, padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                children: [
                                  _buildTabButton(setSheetState, 'Saudi Arabia', isSaudiSelected, () => setSheetState(() => isSaudiSelected = true)),_buildTabButton(setSheetState, 'Other', !isSaudiSelected, () => setSheetState(() => isSaudiSelected = false)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            isSaudiSelected ? _buildSaudiForm(setSheetState) : _buildOtherForm(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SizedBox(
                        width: double.infinity, height: 54,
                        child: ElevatedButton(onPressed: _addNewVehicle, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF237D8C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Add Vehicle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSaudiForm(StateSetter setSheetState) {
    Color plateColor = plateTypes.firstWhere((e) => e['name'] == selectedPlateType)['color'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Plate Type*', style: TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPlateTypePicker(context, setSheetState),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [const Icon(Icons.keyboard_arrow_down, color: Colors.white70), const Spacer(), Text(selectedPlateType, style: const TextStyle(color: Colors.white)), const SizedBox(width: 10), _buildSmallPlateIcon(plateColor)]),
          ),
        ),
        const SizedBox(height: 30),
        _buildPlateDesign(plateColor),
        const SizedBox(height: 30),
        _buildInputField('Plate Letters*', 'ABC', _lettersController),
        const SizedBox(height: 15),
        _buildInputField('Plate Numbers*', '1234', _numbersController),
      ],
    );
  }

  Widget _buildPlateDesign(Color plateColor) {
    return Center(
      child: Container(
        width: 260,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF757575), width: 2)),
        child: IntrinsicHeight(
          child: Row(
            children: [
              const Expanded(child: Center(child: Text('ح ر و ف', style: TextStyle(fontSize: 16, color: Color(0xFF757575))))),
              const VerticalDivider(color: Color(0xFF757575), thickness: 2, width: 2),
              const Expanded(child: Center(child: Text('1 2 3 4', style: TextStyle(fontSize: 16, color: Color(0xFF757575))))),
              const VerticalDivider(color: Color(0xFF757575), thickness: 2, width: 2),
              Container(width: 40, padding: const EdgeInsets.symmetric(vertical: 8), color: plateColor, child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('🇸🇦', style: TextStyle(fontSize: 14)), Text('K\nS\nA', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, height: 1.1, color: Colors.black))])),
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
          title: Text(plateTypes[index]['name'], style: const TextStyle(color: Colors.white)),trailing: _buildSmallPlateIcon(plateTypes[index]['color']),
          onTap: () { parentSetState(() => selectedPlateType = plateTypes[index]['name']); Navigator.pop(context); },
        ),
      ),
    );
  }

  Widget _buildSmallPlateIcon(Color color) {
    return Container(width: 35, height: 22, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3), border: Border.all(color: const Color(0x1F000000))), child: Row(children: [const Expanded(child: SizedBox()), const VerticalDivider(color: Color(0x1F000000), width: 1), const Expanded(child: SizedBox()), Container(width: 8, color: color)]));
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)), const SizedBox(height: 8), TextField(controller: controller, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)))]);
  }

  Widget _buildOtherForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Plate Information*', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)), const SizedBox(height: 15), _buildInputField('Plate Information*', 'Enter plate number', _otherPlateController)]);
  }

  Widget _buildTabButton(StateSetter setSheetState, String title, bool isActive, VoidCallback onTap) {
    return Expanded(child: GestureDetector(onTap: onTap, child: Container(alignment: Alignment.center, decoration: BoxDecoration(color: isActive ? const Color(0xFF237D8C) : Colors.transparent, borderRadius: BorderRadius.circular(10)), child: Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.white60, fontWeight: FontWeight.bold)))));
  }
}