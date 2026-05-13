import 'package:flutter/material.dart';
import 'package:parkliapp/core/services/place_service.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/widgets/place_details_screen.dart';
import 'package:parkliapp/app_data.dart';

enum ExploreCategoryType { hospitals, university, shopping, cafesAndFarms }

class ExploreCategoryScreen extends StatefulWidget {
  final ExploreCategoryType category;

  const ExploreCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<ExploreCategoryScreen> createState() => _ExploreCategoryScreenState();
}

class _ExploreCategoryScreenState extends State<ExploreCategoryScreen> {
  final PlaceService _placeService = PlaceService();

  List<Place> _places = [];
  bool _isLoading = true;
  String? _error;

  String get _categoryKey {
    switch (widget.category) {
      case ExploreCategoryType.hospitals:
        return 'hospitals';
      case ExploreCategoryType.university:
        return 'university';
      case ExploreCategoryType.shopping:
        return 'shopping';
      case ExploreCategoryType.cafesAndFarms:
        return 'cafesAndFarms';
    }
  }

  String get _title {
    switch (widget.category) {
      case ExploreCategoryType.hospitals:
        return AppData.translate('Hospitals', 'مستشفيات');
      case ExploreCategoryType.university:
        return AppData.translate('University', 'جامعات');
      case ExploreCategoryType.shopping:
        return AppData.translate('Shopping', 'تسوق');
      case ExploreCategoryType.cafesAndFarms:
        return AppData.translate('Cafés & Farms', 'كافيهات ومزارع');
    }
  }

  String get _heroImage {
    switch (widget.category) {
      case ExploreCategoryType.hospitals:
        return 'assets/images/explore_hospitals1.png';
      case ExploreCategoryType.university:
        return 'assets/images/explore_university1.png';
      case ExploreCategoryType.shopping:
        return 'assets/images/explore_shopping1.png';
      case ExploreCategoryType.cafesAndFarms:
        return 'assets/images/explore_cafes_farms1.png';
    }
  }

  IconData get _categoryIcon {
    switch (widget.category) {
      case ExploreCategoryType.hospitals:
        return Icons.local_hospital_outlined;
      case ExploreCategoryType.university:
        return Icons.school_outlined;
      case ExploreCategoryType.shopping:
        return Icons.shopping_bag_outlined;
      case ExploreCategoryType.cafesAndFarms:
        return Icons.local_cafe_outlined;
    }
  }

  List<Place> get _popularPlaces => _places.take(3).toList();

  List<Place> get _nearbyPlaces {
    final nearby = _places.where((place) => place.isNearby).toList();
    return nearby.isNotEmpty ? nearby : _places;
  }

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      final places = await _placeService.getPlacesByCategoryGroup(_categoryKey);

      if (!mounted) return;
      setState(() {
        _places = places;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Color _iconBackgroundColor(int index) {
    const colors = [Color(0xFFE3A7A8), Color(0xFFF7EDB3), Color(0xFFA1D5D9)];
    return colors[index % colors.length];
  }

  void _openPlace(BuildContext context, Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceDetailsScreen(place: place)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final popularPlaces = _popularPlaces;
    final nearbyPlaces = _nearbyPlaces;

    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _TopHeader(title: AppData.translate('Explore', 'استكشف')),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _HeroCard(imagePath: _heroImage, title: _title),
                                const SizedBox(height: 16),
                                _SectionTitle(AppData.translate('POPULAR', 'الأكثر شعبية')),
                                const SizedBox(height: 12),
                                if (popularPlaces.isEmpty)
                                  const _EmptyStateCard()
                                else
                                  SizedBox(
                                    height: 192,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: popularPlaces.length,
                                      separatorBuilder: (_, __) => const SizedBox(width: 15),
                                      itemBuilder: (context, index) {
                                        final place = popularPlaces[index];
                                        return _PopularCard(
                                          place: place,
                                          onTap: () => _openPlace(context, place),
                                        );
                                      },
                                    ),
                                  ),
                                const SizedBox(height: 18),
                                _SectionTitle(AppData.translate('NEARBY', 'الأقرب إليك')),
                                const SizedBox(height: 12),
                                if (nearbyPlaces.isEmpty)
                                  const _EmptyStateCard()
                                else
                                  ...nearbyPlaces.asMap().entries.map(
                                    (entry) => Padding(
                                      padding: const EdgeInsets.only(bottom: 14),
                                      child: _NearbyPlaceCard(
                                        place: entry.value,
                                        icon: _categoryIcon,
                                        iconBackgroundColor: _iconBackgroundColor(entry.key),
                                        onTap: () => _openPlace(context, entry.value),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  final String title;
  const _TopHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: AppData.isArabic ? null : 12,
            right: AppData.isArabic ? 12 : null,
            top: 22,
            bottom: 0,
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
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String imagePath;
  final String title;
  const _HeroCard({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
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
              height: 54,
              color: const Color(0x80237D8C),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: AppData.isArabic ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

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

class _PopularCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;
  const _PopularCard({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imagePath = place.imagePath.isNotEmpty
        ? place.imagePath
        : 'assets/images/explore_placeholder.png';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 192,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
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
                height: 48,
                color: const Color(0x80237D8C),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: AppData.isArabic ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  place.displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
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

class _NearbyPlaceCard extends StatelessWidget {
  final Place place;
  final IconData icon;
  final Color iconBackgroundColor;
  final VoidCallback onTap;

  const _NearbyPlaceCard({
    required this.place,
    required this.icon,
    required this.iconBackgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDistance = place.distanceKm < 1
        ? '${(place.distanceKm * 1000).toInt()} ${AppData.translate('m', 'م')}'
        : '${place.distanceKm.toStringAsFixed(1)} ${AppData.translate('km', 'كم')}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xCCF5FBFC),
          border: Border.all(color: const Color(0x30777777)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF1A485F), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF1A485F),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${place.availableSlots} ${AppData.translate('slots available', 'موقف متاح')}',
                    style: const TextStyle(
                      color: Color(0xFF677191),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
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
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xCCF5FBFC),
        border: Border.all(color: const Color(0x30777777)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        AppData.translate('No places available', 'لا توجد أماكن متاحة'),
        style: const TextStyle(
          color: Color(0xFF677191),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}