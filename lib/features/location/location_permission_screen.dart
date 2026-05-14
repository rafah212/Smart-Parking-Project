import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parkliapp/features/home/home_screen.dart';
import 'package:parkliapp/app_data.dart'; 

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool _isLoading = false;

  Future<void> _goToHome() async {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Future<void> _requestLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showMessage(AppData.translate('Please enable location services', 'يرجى تفعيل خدمات الموقع'));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showMessage(AppData.translate('Location permission denied', 'تم رفض إذن الوصول للموقع'));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showOpenSettingsDialog();
        setState(() {
          _isLoading = false;
        });
        return;
      }

      await _goToHome();
    } catch (e) {
      _showMessage(AppData.translate('Something went wrong', 'حدث خطأ ما أثناء طلب الموقع'));
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showOpenSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(AppData.translate('Permission Required', 'الإذن مطلوب')),
            content: Text(
              AppData.translate(
                'Location permission is permanently denied. Please enable it from app settings.',
                'إذن الموقع مرفوض نهائياً. يرجى تفعيله من إعدادات التطبيق لتتمكن من استخدام الخريطة.'
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _goToHome();
                },
                child: Text(AppData.translate('Later', 'لاحقاً'), style: const TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Geolocator.openAppSettings();
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF237D8C)),
                child: Text(AppData.translate('Open Settings', 'فتح الإعدادات'), style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF237D8C);
    const secondaryText = Color(0xFF777777);

    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Expanded(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/location_permission.png',
                          width: 250,
                          height: 260,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 36),
                        Align(
                          alignment: AppData.isArabic ? Alignment.centerRight : Alignment.centerLeft,
                          child: Text(
                            AppData.translate('Allow location access?', 'السماح بالوصول للموقع؟'),
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: AppData.isArabic ? Alignment.centerRight : Alignment.centerLeft,
                          child: Text(
                            AppData.translate(
                              'We need your location access to easily find the nearest parking spots around you.',
                              'نحتاج للوصول إلى موقعك لنسهل عليك العثور على أقرب مواقف السيارات من حولك.'
                            ),
                            style: const TextStyle(
                              color: secondaryText,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _requestLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: primaryColor.withOpacity(0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            AppData.translate('Allow location access', 'السماح بالوصول للموقع'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: TextButton(
                    onPressed: _isLoading ? null : _goToHome,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      AppData.translate('Not Now', 'ليس الآن'),
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}