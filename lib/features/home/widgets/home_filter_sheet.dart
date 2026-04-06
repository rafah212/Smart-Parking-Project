import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class HomeFilterSheet extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback onClose;
  final void Function(double distance, String selectedTime) onApply;
  final double initialDistance;
  final String initialSelectedTime;

  const HomeFilterSheet({
    super.key,
    required this.scrollController,
    required this.onClose,
    required this.onApply,
    required this.initialDistance,
    required this.initialSelectedTime,
  });

  @override
  State<HomeFilterSheet> createState() => _HomeFilterSheetState();
}

class _HomeFilterSheetState extends State<HomeFilterSheet> {
  late double _distance;
  late String _selectedTime;

  // قائمة الخيارات المعربة برمجياً
  List<String> get _timeOptions => [
    AppData.translate('Now', 'الآن'),
    AppData.translate('15 min', '١٥ دقيقة'),
    AppData.translate('30 min', '٣٠ دقيقة'),
    AppData.translate('1 h', '١ ساعة'),
    AppData.translate('3 h', '٣ ساعات'),
    AppData.translate('Tomorrow', 'غداً'),
  ];

  @override
  void initState() {
    super.initState();
    _distance = widget.initialDistance;
    _selectedTime = widget.initialSelectedTime;
  }

  void _resetAll() {
    setState(() {
      _distance = 40;
      _selectedTime = AppData.translate('Now', 'الآن');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(
          controller: widget.scrollController,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppData.translate('FILTER', 'تصفية'),
                  style: const TextStyle(
                    color: Color(0xFF1A485F),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: _resetAll,
                  child: Text(
                    AppData.translate('Reset all', 'إعادة تعيين'),
                    style: const TextStyle(
                      color: Color(0xFF34B5CA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              AppData.translate('Distance', 'المسافة'),
              style: const TextStyle(
                color: Color(0xFF237D8C),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1 ${AppData.translate('km', 'كم')}',
                  style: const TextStyle(
                    color: Color(0xFF237D8C),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '40 ${AppData.translate('km', 'كم')}',
                  style: const TextStyle(
                    color: Color(0xFF237D8C),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
              SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              ),
              child: Slider(
                value: _distance,
                min: 1,
                max: 40,
                divisions: 39,
                activeColor: const Color(0xFF237D8C),
                inactiveColor: const Color(0xFFD9E6E8),
                onChanged: (value) {
                  setState(() {
                    _distance = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppData.translate('Availability Time', 'وقت التوفر'),
              style: const TextStyle(
                color: Color(0xFF237D8C),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _timeOptions.map((time) {
                final isSelected = _selectedTime == time;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF237D8C)
                          : const Color(0xFFF3F5F7),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF5F6C72),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_distance, _selectedTime);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF237D8C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  AppData.translate('Apply Filter', 'تطبيق التصفية'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}