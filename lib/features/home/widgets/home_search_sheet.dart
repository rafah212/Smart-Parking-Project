import 'package:flutter/material.dart';
import 'package:parkliapp/features/home/data/places_dummy_data.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/widgets/explore_category_screen.dart';
import 'package:parkliapp/features/home/widgets/place_details_screen.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class HomeSearchSheet extends StatefulWidget {
  final ScrollController scrollController;

  const HomeSearchSheet({
    super.key,
    required this.scrollController,
  });

  @override
  State<HomeSearchSheet> createState() => _HomeSearchSheetState();
}

class _HomeSearchSheetState extends State<HomeSearchSheet> {
  final TextEditingController _searchController = TextEditingController();

  late List<Place> _nearbyPlaces;
  late List<Place> _searchResults;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _nearbyPlaces = dummyPlaces.where((place) => place.isNearby).toList();
    _searchResults = [];
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    final results = dummyPlaces.where((place) {
      final q = query.toLowerCase();
      return place.name.toLowerCase().contains(q) ||
          place.branchName.toLowerCase().contains(q) ||
          place.category.toLowerCase().contains(q);
    }).toList();

    setState(() {
      _isSearching = true;
      _searchResults = results;
    });
  }

  void _openPlaceDetails(BuildContext context, Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceDetailsScreen(place: place),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Place> visiblePlaces =
        _isSearching ? _searchResults : _nearbyPlaces;

    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          controller: widget.scrollController,
          padding: const EdgeInsets.fromLTRB(13, 12, 13, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: _TopHandle()),
              const SizedBox(height: 16),
              _SearchRow(controller: _searchController),
              const SizedBox(height: 20),

              _SectionLabel(_isSearching 
                ? AppData.translate('RESULTS', 'النتائج') 
                : AppData.translate('NEARBY', 'الأقرب إليك')),
              const SizedBox(height: 10),

              if (visiblePlaces.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xCCF5FBFC),
                    border: Border.all(color: const Color(0x30777777)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppData.translate('No places found', 'لم يتم العثور على أماكن'),
                    style: const TextStyle(
                      color: Color(0xFF4E5568),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                     ),
                )
              else
                ...visiblePlaces.map(
                  (place) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _NearbyPlaceCard(
                      place: place,
                      onTap: () => _openPlaceDetails(context, place),
                    ),
                  ),
                ),

              if (!_isSearching) ...[
                const SizedBox(height: 10),
                _SectionLabel(AppData.translate('EXPLORE', 'استكشف')),
                const SizedBox(height: 14),
                const _ExploreSection(),
              ],

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopHandle extends StatelessWidget {
  const _TopHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 81,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0x26777777),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  final TextEditingController controller;
  const _SearchRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SearchField(controller: controller)),
        const SizedBox(width: 10),
        const _FilterButton(),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFF5FBFC),
        border: Border.all(color: const Color(0x30777777)),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search, color: Color(0xFF8D8D8D), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: AppData.isArabic ? TextAlign.right : TextAlign.left,
              decoration: InputDecoration(
                hintText: AppData.translate('Search', 'بحث'),
                hintStyle: const TextStyle(
                  color: Color(0xFF8D8D8D),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: const TextStyle(
                color: Color(0xFF1A485F),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFF5FBFC),
        border: Border.all(color: const Color(0x30777777)),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.tune_rounded,
        color: Color(0xFF237D8C),
        size: 22,
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF677191),
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.7,
      ),
    );
  }
}

class _NearbyPlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  const _NearbyPlaceCard({
    required this.place,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDistance;
    if (place.distanceKm < 1) {
      formattedDistance = '${(place.distanceKm * 1000).toInt()} ${AppData.
      translate('m', 'م')}';
    } else {
      formattedDistance = '${place.distanceKm} ${AppData.translate('km', 'كم')}';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xCCF5FBFC),
          border: Border.all(color: const Color(0x30777777)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFA1D5D9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    color: Color(0xFF1A485F),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF1A485F),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${place.availableSlots} ${AppData.translate('slots available', 'موقف متاح')}',
                    style: const TextStyle(
                      color: Color(0xFF4E5568),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formattedDistance,
              style: const TextStyle(
                color: Color(0xFF237D8C),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreSection extends StatelessWidget {
  const _ExploreSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _ExploreCard(
                imagePath: 'assets/images/explore_university.png',
                title: AppData.translate('University', 'جامعات'),
                height: 170,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExploreCategoryScreen(
                        category: ExploreCategoryType.university,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              _ExploreCard(
                imagePath: 'assets/images/explore_cafes_farms.png',
                title: AppData.translate('Cafés & Farms', 'كافيهات ومزارع'),
                height: 210,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExploreCategoryScreen(
                        category: ExploreCategoryType.cafesAndFarms,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            children: [
              _ExploreCard(
                imagePath: 'assets/images/explore_hospitals.png',
                title: AppData.translate('Hospitals', 'مستشفيات'),
                height: 210,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExploreCategoryScreen(
                        category: ExploreCategoryType.hospitals,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              _ExploreCard(
                imagePath: 'assets/images/explore_shopping.png',
                title: AppData.translate('Shopping', 'تسوق'),
                height: 170,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExploreCategoryScreen(
                        category: ExploreCategoryType.shopping,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final double height;
  final VoidCallback? onTap;

  const _ExploreCard({
    required this.imagePath,
    required this.title,
    required this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 52,
                color: const Color(0x80237D8C),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(
                      AppData.isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}