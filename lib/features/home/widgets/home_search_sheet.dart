import 'package:flutter/material.dart';

class HomeSearchSheet extends StatelessWidget {
  final ScrollController scrollController;

  const HomeSearchSheet({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(13, 12, 13, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Center(child: _TopHandle()),
            SizedBox(height: 16),
            _SearchRow(),
            SizedBox(height: 20),
            _SectionLabel('NEARBY'),
            SizedBox(height: 10),
            _NearbyPlaceCard(
              title: 'Unaizah Collage of Pharmacy',
              slotsText: '35 slots available',
              distance: '600m',
            ),
            SizedBox(height: 14),
            _NearbyPlaceCard(
              title: 'Al-Othaim Mall',
              slotsText: '45 slots available',
              distance: '950m',
            ),
            SizedBox(height: 14),
            _NearbyPlaceCard(
              title: 'King Saud Hospital',
              slotsText: '39 slots available',
              distance: '1.2 km',
            ),
            SizedBox(height: 24),
            _SectionLabel('EXPLORE'),
            SizedBox(height: 14),
            _ExploreSection(),
            SizedBox(height: 30),
          ],
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
  const _SearchRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _SearchField()),
        SizedBox(width: 10),
        _FilterButton(),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Color(0xFF8D8D8D),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: TextStyle(
                color: Color(0xFF1A485F),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 14),
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
  final String title;
  final String slotsText;
  final String distance;

  const _NearbyPlaceCard({
    required this.title,
    required this.slotsText,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  title,
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
                  slotsText,
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
            distance,
            style: const TextStyle(
              color: Color(0xFF237D8C),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreSection extends StatelessWidget {
  const _ExploreSection();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _ExploreCard(
                imagePath: 'assets/images/explore_university.png',
                title: 'University',
                height: 170,
              ),
              SizedBox(height: 15),
              _ExploreCard(
                imagePath: 'assets/images/explore_cafes_farms.png',
                title: 'Cafés & Farms',
                height: 210,
              ),
            ],
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            children: [
              _ExploreCard(
                imagePath: 'assets/images/explore_hospitals.png',
                title: 'Hospitals',
                height: 210,
              ),
              SizedBox(height: 15),
              _ExploreCard(
                imagePath: 'assets/images/explore_shopping.png',
                title: 'Shopping',
                height: 170,
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

  const _ExploreCard({
    required this.imagePath,
    required this.title,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}