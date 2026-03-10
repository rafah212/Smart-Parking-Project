import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFF5FBFC),
          border: Border.all(color: const Color(0x30777777)),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Row(
          children: [
            SizedBox(width: 14),
            Icon(Icons.search, color: Color(0xFF8D8D8D), size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search',
                style: TextStyle(
                  color: Color(0xFF8D8D8D),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}