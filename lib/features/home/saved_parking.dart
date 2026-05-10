import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/saved_places_service.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/widgets/place_details_screen.dart';
import 'package:parkliapp/core/services/app_session_service.dart';

class SavedParking extends StatefulWidget {
  const SavedParking({super.key});

  @override
  State<SavedParking> createState() => _SavedParkingState();
}

class _SavedParkingState extends State<SavedParking> {
  final SavedPlacesService _savedPlacesService = SavedPlacesService();
  final AppSessionService _appSessionService = AppSessionService();

  List<Place> _savedPlaces = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSavedPlaces();
  }

  Future<void> _loadSavedPlaces() async {
    final session = await _appSessionService.getCurrentSession();

    if (session == null) {
      setState(() {
        _error = AppData.translate(
          'You need to log in first',
          'يجب تسجيل الدخول أولاً',
        );
        _isLoading = false;
      });
      return;
    }

    try {
      final places = await _savedPlacesService.getSavedPlaces(session.userId);

      if (!mounted) return;
      setState(() {
        _savedPlaces = places;
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

  Future<void> _removeSavedPlace(Place place) async {
    final session = await _appSessionService.getCurrentSession();

    if (session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppData.translate(
              'You need to log in first',
              'يجب تسجيل الدخول أولاً',
            ),
          ),
        ),
      );
      return;
    }

    try {
      await _savedPlacesService.removeSavedPlace(
        userId: session.userId,
        placeId: place.id,
      );

      if (!mounted) return;
      setState(() {
        _savedPlaces.removeWhere((p) => p.id == place.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            AppData.translate(
              '${place.name} removed from saved',
              'تمت إزالة ${place.name} من المحفوظات',
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  AppData.translate('Saved', 'المحفوظة'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      )
                    : _savedPlaces.isEmpty
                        ? Center(
                            child: Text(
                              AppData.translate(
                                'No saved places yet',
                                'لا توجد أماكن محفوظة حالياً',
                              ),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            itemCount: _savedPlaces.length,
                            itemBuilder: (context, index) {
                              final place = _savedPlaces[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      index == _savedPlaces.length - 1 ? 0 : 16,
                                ),
                                child: _SavedPlaceCard(
                                  place: place,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PlaceDetailsScreen(place: place),
                                      ),
                                    );
                                  },
                                  onRemove: () => _removeSavedPlace(place),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class _SavedPlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _SavedPlaceCard({
    required this.place,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FCFD),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF237D8C), width: 0.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      color: Color(0xFF414141),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${place.availableSlots}/${place.totalSlots} ${AppData.translate('slots available', 'موقف متاح')}',
                    style: const TextStyle(
                      color: Color(0xFFB8B8B8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(
                Icons.star,
                color: Color(0xFF237D8C),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
