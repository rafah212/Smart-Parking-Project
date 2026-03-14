import 'package:flutter/material.dart';

enum ExploreCategoryType { hospitals, university, shopping, cafesAndFarms }

class ExploreCategoryScreen extends StatelessWidget {
  final ExploreCategoryType category;

  const ExploreCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final data = _categoryData[category]!;

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
                    _HeroCard(imagePath: data.heroImage, title: data.title),
                    const SizedBox(height: 16),
                    const _SectionTitle('POPULAR'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 192,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.popularPlaces.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 15),
                        itemBuilder: (context, index) {
                          final place = data.popularPlaces[index];
                          return _PopularCard(place: place);
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _SectionTitle('NEARBY'),
                    const SizedBox(height: 12),
                    ...data.nearbyPlaces.map(
                      (place) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _NearbyPlaceCard(place: place),
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
          Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
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
  final CategoryPlace place;

  const _PopularCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 192,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(place.imagePath, fit: BoxFit.cover),
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
    );
  }
}

class _NearbyPlaceCard extends StatelessWidget {
  final CategoryPlace place;

  const _NearbyPlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: place.iconBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(place.icon, color: const Color(0xFF1A485F), size: 18),
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
                  '${place.slots} slots available',
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
            place.distance,
            style: const TextStyle(
              color: Color(0xFF237D8C),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryPlace {
  final String name;
  final String imagePath;
  final int slots;
  final String distance;
  final IconData icon;
  final Color iconBackgroundColor;

  const CategoryPlace({
    required this.name,
    required this.imagePath,
    required this.slots,
    required this.distance,
    required this.icon,
    required this.iconBackgroundColor,
  });
}

class CategoryScreenData {
  final String title;
  final String heroImage;
  final List<CategoryPlace> popularPlaces;
  final List<CategoryPlace> nearbyPlaces;

  const CategoryScreenData({
    required this.title,
    required this.heroImage,
    required this.popularPlaces,
    required this.nearbyPlaces,
  });
}

const Map<ExploreCategoryType, CategoryScreenData> _categoryData = {
  ExploreCategoryType.hospitals: CategoryScreenData(
    title: 'Hospitals',
    heroImage: 'assets/images/explore_hospitals1.png',
    popularPlaces: [
      CategoryPlace(
        name: 'King Saud Hospital',
        imagePath: 'assets/images/hospital_1.png',
        slots: 4,
        distance: '1.2 km',
        icon: Icons.local_hospital_outlined,
        iconBackgroundColor: Color(0xFFE3A7A8),
      ),
      CategoryPlace(
        name: 'Hayat Hospital',
        imagePath: 'assets/images/hospital_2.png',
        slots: 9,
        distance: '9.1 km',
        icon: Icons.local_hospital_outlined,
        iconBackgroundColor: Color(0xFFF7EDB3),
      ),
      CategoryPlace(
        name: 'Dr. Sulaiman Al-Habib Hospital',
        imagePath: 'assets/images/hospital_3.png',
        slots: 25,
        distance: '34 km',
        icon: Icons.local_hospital_outlined,
        iconBackgroundColor: Color(0xFFA1D5D9),
      ),
    ],
    nearbyPlaces: [
      CategoryPlace(
        name: 'King Saud Hospital',
        imagePath: 'assets/images/hospital_1.png',
        slots: 4,
        distance: '1.2 km',
        icon: Icons.local_hospital_outlined,
        iconBackgroundColor: Color(0xFFE3A7A8),
      ),
      CategoryPlace(
        name: 'Hayat Hospital',
        imagePath: 'assets/images/hospital_2.png',
        slots: 9,
        distance: '9.1 km',
        icon: Icons.local_hospital_outlined,
        iconBackgroundColor: Color(0xFFF7EDB3),
      ),
      CategoryPlace(
        name: 'Dr. Sulaiman Al-Habib Hospital',
        imagePath: 'assets/images/hospital_3.png',
        slots: 25,
        distance: '34 km',
        icon: Icons.local_hospital_outlined,
        iconBackgroundColor: Color(0xFFA1D5D9),
      ),
    ],
  ),

  ExploreCategoryType.university: CategoryScreenData(
    title: 'University',
    heroImage: 'assets/images/explore_university1.png',
    popularPlaces: [
      CategoryPlace(
        name: 'Unaizah College of Pharmacy',
        imagePath: 'assets/images/university_1.png',
        slots: 35,
        distance: '600m',
        icon: Icons.school_outlined,
        iconBackgroundColor: Color(0xFFA1D5D9),
      ),
      CategoryPlace(
        name: 'College of Science & Arts',
        imagePath: 'assets/images/university_2.png',
        slots: 18,
        distance: '1.5 km',
        icon: Icons.school_outlined,
        iconBackgroundColor: Color(0xFFF7EDB3),
      ),
      CategoryPlace(
        name: 'Onaizah Colleges',
        imagePath: 'assets/images/university_3.png',
        slots: 27,
        distance: '3.2 km',
        icon: Icons.school_outlined,
        iconBackgroundColor: Color(0xFFE3A7A8),
      ),
    ],
    nearbyPlaces: [
      CategoryPlace(
        name: 'Unaizah College of Pharmacy',
        imagePath: 'assets/images/university_1.png',
        slots: 35,
        distance: '600m',
        icon: Icons.school_outlined,
        iconBackgroundColor: Color(0xFFA1D5D9),
      ),
      CategoryPlace(
        name: 'College of Science & Arts',
        imagePath: 'assets/images/university_2.png',
        slots: 18,
        distance: '1.5 km',
        icon: Icons.school_outlined,
        iconBackgroundColor: Color(0xFFF7EDB3),
      ),
      CategoryPlace(
        name: 'Onaizah Colleges',
        imagePath: 'assets/images/university_3.png',
        slots: 27,
        distance: '3.2 km',
        icon: Icons.school_outlined,
        iconBackgroundColor: Color(0xFFE3A7A8),
      ),
    ],
  ),

  ExploreCategoryType.shopping: CategoryScreenData(
    title: 'Shopping',
    heroImage: 'assets/images/explore_shopping1.png',
    popularPlaces: [
      CategoryPlace(
        name: 'Al-Othaim Mall',
        imagePath: 'assets/images/shopping_1.png',
        slots: 45,
        distance: '950m',
        icon: Icons.shopping_bag_outlined,
        iconBackgroundColor: Color(0xFFA1D5D9),
      ),
      CategoryPlace(
        name: 'Unaizah Mall',
        imagePath: 'assets/images/shopping_2.png',
        slots: 21,
        distance: '2.4 km',
        icon: Icons.shopping_bag_outlined,
        iconBackgroundColor: Color(0xFFF7EDB3),
      ),
      CategoryPlace(
        name: 'Boulevard Unaizah',
        imagePath: 'assets/images/shopping_3.png',
        slots: 16,
        distance: '4.1 km',
        icon: Icons.shopping_bag_outlined,
        iconBackgroundColor: Color(0xFFE3A7A8),
      ),
    ],
    nearbyPlaces: [
      CategoryPlace(
        name: 'Al-Othaim Mall',
        imagePath: 'assets/images/shopping_1.png',
        slots: 45,
        distance: '950m',
        icon: Icons.shopping_bag_outlined,
        iconBackgroundColor: Color(0xFFA1D5D9),
      ),
      CategoryPlace(
        name: 'Unaizah Mall',
        imagePath: 'assets/images/shopping_2.png',
        slots: 21,
        distance: '2.4 km',
        icon: Icons.shopping_bag_outlined,
        iconBackgroundColor: Color(0xFFF7EDB3),
      ),
      CategoryPlace(
        name: 'Boulevard Unaizah',
        imagePath: 'assets/images/shopping_3.png',
        slots: 16,
        distance: '4.1 km',
        icon: Icons.shopping_bag_outlined,
        iconBackgroundColor: Color(0xFFE3A7A8),
      ),
    ],
  ),

  ExploreCategoryType.cafesAndFarms: CategoryScreenData(
    title: 'Cafés & Farms',
    heroImage: 'assets/images/explore_cafes_farms1.png',
    popularPlaces: [
      CategoryPlace(
        name: 'Jada Al-Nakheel',
        imagePath: 'assets/images/cafe_1.png',
        slots: 24,
        distance: '5.7 km',
        icon: Icons.local_cafe_outlined,
        iconBackgroundColor: Color(0xFFA1D5D9),
      ),
      CategoryPlace(
        name: 'Gomar Farm',
        imagePath: 'assets/images/cafe_2.png',
        slots: 14,
        distance: '6.2 km',
        icon: Icons.park_outlined,
        iconBackgroundColor: Color(0xFFF7EDB3),
      ),
      CategoryPlace(
        name: 'ًWaref Farm',
        imagePath: 'assets/images/cafe_3.png',
        slots: 11,
        distance: '7.1 km',
        icon: Icons.local_cafe_outlined,
        iconBackgroundColor: Color(0xFFE3A7A8),
      ),
    ],
    nearbyPlaces: [
      CategoryPlace(
        name: 'Jada Al-Nakheel',
        imagePath: 'assets/images/cafe_1.png',
        slots: 24,
        distance: '5.7 km',
        icon: Icons.local_cafe_outlined,
        iconBackgroundColor: Color(0xFFA1D5D9),
      ),
      CategoryPlace(
        name: 'Gomar Farm',
        imagePath: 'assets/images/cafe_2.png',
        slots: 14,
        distance: '6.2 km',
        icon: Icons.park_outlined,
        iconBackgroundColor: Color(0xFFF7EDB3),
      ),
      CategoryPlace(
        name: 'Waref Farm',
        imagePath: 'assets/images/cafe_3.png',
        slots: 11,
        distance: '7.1 km',
        icon: Icons.local_cafe_outlined,
        iconBackgroundColor: Color(0xFFE3A7A8),
      ),
    ],
  ),
};
