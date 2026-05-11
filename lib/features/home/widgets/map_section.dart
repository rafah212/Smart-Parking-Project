import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/widgets/place_details_screen.dart';

class MapSection extends StatefulWidget {
  final MapController? mapController;
  final List<Place> places;

  const MapSection({
    super.key,
    this.mapController,
    this.places = const [],
  });

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  late final MapController _internalMapController;

  MapController get _effectiveController =>
      widget.mapController ?? _internalMapController;

  LatLng? _userLatLng;
  bool _isLoading = true;
  String? _errorMessage;

  static const LatLng _defaultLocation =
      LatLng(26.0900, 43.9870); // عنيزة تقريبًا

  @override
  void initState() {
    super.initState();
    _internalMapController = MapController();
    _loadUserLocationIfAllowed();
  }

  Future<void> _loadUserLocationIfAllowed() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          _userLatLng = null;
          _errorMessage = AppData.translate(
            'Location service is turned off',
            'خدمات الموقع متوقفة',
          );
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          _userLatLng = null;
          _errorMessage = AppData.translate(
            'Location permission not granted',
            'إذن الموقع غير مفعّل',
          );
          _isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final userLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _userLatLng = userLocation;
        _errorMessage = null;
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _effectiveController.move(userLocation, 15);
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _userLatLng = null;
        _errorMessage = AppData.translate(
          'Using default location',
          'يتم استخدام الموقع الافتراضي',
        );
        _isLoading = false;
      });
    }
  }

  List<Marker> _buildPlaceMarkers() {
    return widget.places
        .where((place) => place.lat != 0 && place.lng != 0)
        .map(
          (place) => Marker(
            point: LatLng(place.lat, place.lng),
            width: 52,
            height: 52,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlaceDetailsScreen(place: place),
                  ),
                );
              },
              child: _ParkLiPlaceMarker(place: place),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = _userLatLng ?? _defaultLocation;

    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: SizedBox(
        height: 260,
        width: double.infinity,
        child: Stack(
          children: [
            if (_isLoading)
              Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF237D8C),
                  ),
                ),
              )
            else
              FlutterMap(
                mapController: _effectiveController,
                options: MapOptions(
                  initialCenter: currentLocation,
                  initialZoom: _userLatLng != null ? 15 : 12,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.parkliapp',
                  ),
                  MarkerLayer(
                    markers: [
                      ..._buildPlaceMarkers(),
                      Marker(
                        point: currentLocation,
                        width: 42,
                        height: 42,
                        child: const _UserLocationMarker(),
                      ),
                    ],
                  ),
                ],
              ),
            if (_errorMessage != null)
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            Positioned(
              right: AppData.isArabic ? null : 14,
              left: AppData.isArabic ? 14 : null,
              bottom: 14,
              child: FloatingActionButton.small(
                heroTag: 'location_btn',
                backgroundColor: Colors.white,
                onPressed: _loadUserLocationIfAllowed,
                child: const Icon(
                  Icons.my_location,
                  color: Color(0xFF237D8C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParkLiPlaceMarker extends StatelessWidget {
  const _ParkLiPlaceMarker({
    required this.place,
  });

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: place.name,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF237D8C),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/parkli_logo.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                color: const Color(0xFFEAF4F5),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.local_parking_rounded,
                  color: Color(0xFF237D8C),
                  size: 24,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _UserLocationMarker extends StatelessWidget {
  const _UserLocationMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F80ED),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }
}
