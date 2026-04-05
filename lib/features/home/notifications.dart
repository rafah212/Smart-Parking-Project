import 'package:flutter/material.dart';
import 'package:parkliapp/core/services/notifications_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationsService _notificationsService = NotificationsService();

  List<AppNotificationItem> _notifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      setState(() {
        _error = 'You need to log in first';
        _isLoading = false;
      });
      return;
    }

    try {
      final items = await _notificationsService.getNotifications(user.id);

      if (!mounted) return;
      setState(() {
        _notifications = items;
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

  String _timeAgo(DateTime? createdAt) {
    if (createdAt == null) return 'Now';

    final diff = DateTime.now().difference(createdAt);

    if (diff.inMinutes < 1) return 'Now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} hour';
    return '${diff.inDays} day';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              constraints: const BoxConstraints(minHeight: 812),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 110,
                      decoration: const ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.50, -0.00),
                          end: Alignment(0.50, 1.00),
                          colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                      ),
                      child: SafeArea(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: 10,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                            const Text(
                              'Notifications',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 130,
                    left: 0,
                    right: 0,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _error != null
                            ? Padding(
                                padding: const EdgeInsets.all(24),
                                child: Text(
                                  _error!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              )
                            : _notifications.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Text(
                                      'No notifications yet',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                : Column(
                                    children: _notifications.map((item) {
                                      return Container(
                                        color: item.isRead
                                            ? Colors.white
                                            : const Color(0xFFF3F6FF),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 16,
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (!item.isRead)
                                              Container(
                                                width: 5,
                                                height: 60,
                                                margin: const EdgeInsets.only(right: 12),
                                                color: const Color(0xA3237D8C),
                                              ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.title,
                                                    style: const TextStyle(
                                                      color: Color(0xFF237D8C),
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: 'Lato',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    item.body,
                                                    style: const TextStyle(
                                                      color: Color(0xFF677191),
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Lato',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              _timeAgo(item.createdAt),
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                color: Color(0xFF237D8C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Lato',
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}