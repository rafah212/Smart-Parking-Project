import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:parkliapp/core/services/saved_places_service.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/widgets/parking_lot_screen.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/features/home/help_support_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final Place place;

  const PlaceDetailsScreen({super.key, required this.place});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  final SavedPlacesService _savedPlacesService = SavedPlacesService();

  bool _isSaved = false;
  bool _isLoadingSavedState = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      if (!mounted) return;
      setState(() {
        _isSaved = false;
        _isLoadingSavedState = false;
      });
      return;
    }

    try {
      final isSaved = await _savedPlacesService.isPlaceSaved(
        userId: user.id,
        placeId: widget.place.id,
      );

      if (!mounted) return;
      setState(() {
        _isSaved = isSaved;
        _isLoadingSavedState = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingSavedState = false;
      });
    }
  }

  Future<void> _toggleSavedPlace() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            AppData.translate('You need to log in first', 'يجب تسجيل الدخول أولاً'),
          ),
        ),
      );
      return;
    }

    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      if (_isSaved) {
        await _savedPlacesService.removeSavedPlace(
          userId: user.id,
          placeId: widget.place.id,
        );

        if (!mounted) return;
        setState(() {
          _isSaved = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              AppData.translate(
                '${widget.place.name} removed from saved',
                'تمت إزالة ${widget.place.name} من المحفوظات',
              ),
            ),
          ),
        );
      } else {
        await _savedPlacesService.savePlace(
          userId: user.id,
          placeId: widget.place.id,
        );

        if (!mounted) return;
        setState(() {
          _isSaved = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              AppData.translate(
                '${widget.place.name} saved successfully',
                'تم حفظ ${widget.place.name} بنجاح',
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _openDirections() async {
    if (widget.place.lat == 0 && widget.place.lng == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            AppData.translate(
              'Location is not available for this place',
              'الموقع غير متوفر لهذا المكان',
            ),
          ),
        ),
      );
      return;
    }

    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${widget.place.lat},${widget.place.lng}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formattedDistance() {
    if (widget.place.distanceKm < 1) {
      return '${(widget.place.distanceKm * 1000).toInt()} ${AppData.translate('m', 'م')}';
    }
    return '${widget.place.distanceKm.toStringAsFixed(1)} ${AppData.translate('km', 'كم')}';
  }

  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(widget.place.lat, widget.place.lng);
    final bool hasLocation = widget.place.lat != 0 || widget.place.lng != 0;

    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: hasLocation
                  ? FlutterMap(
                      options: MapOptions(
                        initialCenter: location,
                        initialZoom: 15.5,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.parkliapp',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: location,
                              width: 56,
                              height: 56,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.local_parking_rounded,
                                  color: Color(0xFF237D8C),
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: location,
                              radius: 45,
                              color: const Color(0x33237D8C),
                              borderColor: const Color(0x66237D8C),
                              borderStrokeWidth: 1.5,
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      color: const Color(0xFFF4F7F8),
                      alignment: Alignment.center,
                      child: Text(
                        AppData.translate('Location is not available', 'الموقع غير متوفر'),
                        style: const TextStyle(
                          color: Color(0xFF607176),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
            Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _TopBar(
                    title: AppData.translate('Search', 'بحث'),
                    onBack: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: _SearchPreviewBar(text: widget.place.name),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 270,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 32,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: _TopHandle()),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.place.name,
                              style: const TextStyle(
                                color: Color(0xFF1A485F),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0x1F000000)),
                            ),
                            child: IconButton(
                              onPressed: _isLoadingSavedState || _isSaving
                                  ? null
                                  : _toggleSavedPlace,
                              icon: _isLoadingSavedState
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF237D8C),
                                      ),
                                    )
                                  : Icon(
                                      _isSaved
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: const Color(0xFF237D8C),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _InfoRow(
                        icon: Icons.place_outlined,
                        text: widget.place.branchName.isNotEmpty
                            ? widget.place.branchName
                            : widget.place.category,
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(
                        icon: Icons.local_parking_outlined,
                        text:
                            '${widget.place.availableSlots}/${widget.place.totalSlots} ${AppData.translate('Total slots available', 'إجمالي المواقف المتاحة')}',
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(
                        icon: Icons.social_distance_outlined,
                        text: _formattedDistance(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.call_outlined,
                              text: AppData.translate('Call support', 'اتصال بالدعم'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HelpSupportScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.directions_outlined,
                              text: AppData.translate('Get directions', 'الاتجاهات'),
                              onTap: _openDirections,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              widget.place.priceLabel,
                              style: const TextStyle(
                                color: Color(0xFF237D8C),
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ParkingLotScreen(place: widget.place),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF237D8C),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: Text(
                                  AppData.translate('Choose Spot', 'اختر موقفاً'),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
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

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  const _TopBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            left: AppData.isArabic ? null : 8,
            right: AppData.isArabic ? 8 : null,
            top: 0,
            bottom: 0,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchPreviewBar extends StatelessWidget {
  final String text;
  const _SearchPreviewBar({required this.text});

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
          const Icon(Icons.search, color: Color(0xFF1A485F), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF1A485F),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF7A7A7A)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: const Color(0xFF07434E)),
        label: Text(
          text,
          style: const TextStyle(color: Color(0xFF07434E), fontSize: 13),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.black.withOpacity(0.20)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}