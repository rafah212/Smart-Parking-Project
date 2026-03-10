import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapSection extends StatefulWidget {
  const MapSection({super.key});

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  final MapController _mapController = MapController();

  LatLng? _userLatLng;
  bool _isLoading = true;
  String? _errorMessage;

  static const LatLng _defaultLocation = LatLng(24.7136, 46.6753); // Riyadh

  @override
  void initState() {
    super.initState();
    _loadUserLocationIfAllowed();
  }

  Future<void> _loadUserLocationIfAllowed() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location service is turned off';
          _isLoading = false;
        });
        return;
      }

      final permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permission not granted';
          _isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final userLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _userLatLng = userLocation;
        _isLoading = false;
        _errorMessage = null;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(userLocation, 15);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Using default location';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = _userLatLng ?? _defaultLocation;

    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        children: [
          if (_isLoading)
            Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentLocation,
                initialZoom: _userLatLng != null ? 15 : 11,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.parkliapp',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentLocation,
                      width: 40,
                      height: 40,
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
            right: 14,
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
    );
  }
}

class _UserLocationMarker extends StatelessWidget {
  const _UserLocationMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: const Color(0xFF2F80ED),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
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