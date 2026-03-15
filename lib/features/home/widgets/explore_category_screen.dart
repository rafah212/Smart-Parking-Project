import 'package:flutter/material.dart';
import 'package:parkliapp/features/home/data/places_dummy_data.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/widgets/place_details_screen.dart';

enum ExploreCategoryType { hospitals, university, shopping, cafesAndFarms }

class ExploreCategoryScreen extends StatelessWidget {
  final ExploreCategoryType category;

  const ExploreCategoryScreen({
    super.key,
    required this.category,
  });

  String get _categoryKey {
    switch (category) {
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
    switch (category) {
      case ExploreCategoryType.hospitals:
        return 'Hospitals';
      case ExploreCategoryType.university:
        return 'University';
      case ExploreCategoryType.shopping:
        return 'Shopping';
      case ExploreCategoryType.cafesAndFarms:
        return 'Cafés & Farms';
    }
  }

  String get _heroImage {
    switch (category) {
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
    switch (category) {
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

  List<Place> get _categoryPlaces {
    return dummyPlaces.where((place) => place.category == _categoryKey).toList();
  }

  List<Place> get _popularPlaces {
    final places = _categoryPlaces;
    return places.take(3).toList();
  }

  List<Place> get _nearbyPlaces {
    final nearby = _categoryPlaces.where((place) => place.isNearby).toList();
    return nearby.isNotEmpty ? nearby : _categoryPlaces;
  }

  Color _iconBackgroundColor(int index) {
    const colors = [
      Color(0xFFE3A7A8),
      Color(0xFFF7EDB3),
      Color(0xFFA1D5D9),
    ];
    return colors[index % colors.length];
  }

  void _openPlace(BuildContext context, Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceDetailsScreen(place: place),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final popularPlaces = _popularPlaces;
    final nearbyPlaces = _nearbyPlaces;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopHeader(title: 'Explore'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroCard(
                      imagePath: _heroImage,
                      title: _title,
                    ),
                    const SizedBox(height: 16),
                    const _SectionTitle('POPULAR'),
                    const SizedBox(height: 12),

                    if (popularPlaces.isEmpty)
                      const _EmptyStateCard()
                    else
                      SizedBox(
                        height: 192,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: popularPlaces.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 15),
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
                    const _SectionTitle('NEARBY'),
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
                            iconBackgroundColor:
                                _iconBackgroundColor(entry.key),
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
    );
  }
}

class _TopHeader extends StatelessWidget {
  final String title;

  const _TopHeader({
    required this.title,
  });

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
            left: 12,
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

  const _HeroCard({
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
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
              height: 54,
              color: const Color(0x80237D8C),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
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

  const _PopularCard({
    required this.place,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 192,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                place.imagePath,
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
                alignment: Alignment.centerLeft,
                child: Text(
                  place.name,
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
    String formattedDistance;
    if (place.distanceKm < 1) {
      formattedDistance = '${(place.distanceKm * 1000).toInt()}m';
    } else {
      formattedDistance = '${place.distanceKm} km';
    }

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
              child: Icon(
                icon,
                color: const Color(0xFF1A485F),
                size: 18,
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
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${place.availableSlots} slots available',
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
      child: const Text(
        'No places available',
        style: TextStyle(
          color: Color(0xFF677191),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}