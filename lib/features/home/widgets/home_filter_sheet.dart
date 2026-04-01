import 'package:flutter/material.dart';

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

  final List<String> _timeOptions = [
    'Now',
    '15 min',
    '30 min',
    '1 h',
    '3 h',
    'Tomorrow',
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
      _selectedTime = 'Now';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const Text(
                'FILTER',
                style: TextStyle(
                  color: Color(0xFF1A485F),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: _resetAll,
                child: const Text(
                  'Reset all',
                  style: TextStyle(
                    color: Color(0xFF34B5CA),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Distance',
            style: TextStyle(
              color: Color(0xFF237D8C),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 km',
                style: TextStyle(
                  color: Color(0xFF237D8C),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '40 km',
                style: TextStyle(
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
          const Text(
            'Availability Time',
            style: TextStyle(
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
              child: const Text(
                'Apply Filter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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