import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/notifications_service.dart';
import 'package:parkliapp/core/services/app_session_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationsService _notificationsService = NotificationsService();
  final AppSessionService _appSessionService = AppSessionService();

  List<AppNotificationItem> _notifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
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
      final items =
          await _notificationsService.getNotifications(session.userId);

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

  // دالة الحذف النهائي من الواجهة ومن قاعدة البيانات
  Future<void> _removeNotification(int index) async {
    final item = _notifications[index];

    // 1. الحذف من الواجهة فوراً (تجربة مستخدم سريعة)
    setState(() {
      _notifications.removeAt(index);
    });

    try {
      // 2. الحذف من قاعدة البيانات Supabase
      await Supabase.instance.client
          .from('notifications')
          .delete()
          .match({'id': item.id});
    } catch (e) {
      debugPrint('Error deleting notification from server: $e');
    }
  }

  String _timeAgo(DateTime? createdAt) {
    if (createdAt == null) {
      return AppData.translate('Now', 'الآن');
    }

    final diff = DateTime.now().difference(createdAt);

    if (diff.inMinutes < 1) {
      return AppData.translate('Now', 'الآن');
    }
    if (diff.inMinutes < 60) {
      return AppData.isArabic
          ? '${diff.inMinutes} دقيقة'
          : '${diff.inMinutes} min';
    }
    if (diff.inHours < 24) {
      return AppData.isArabic ? '${diff.inHours} ساعة' : '${diff.inHours} hour';
    }
    return AppData.isArabic ? '${diff.inDays} يوم' : '${diff.inDays} day';
  }

  String _titleOf(AppNotificationItem item) {
    final title = item.title.trim();
    if (title.isNotEmpty) return title;

    return AppData.translate('Notification', 'إشعار');
  }

  String _bodyOf(AppNotificationItem item) {
    final body = item.body.trim();
    if (body.isNotEmpty) return body;

    return AppData.translate(
      'No additional details',
      'لا توجد تفاصيل إضافية',
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // الهيدر
            Container(
              width: screenWidth,
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
                      left: AppData.isArabic ? null : 10,
                      right: AppData.isArabic ? 10 : null,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    Text(
                      AppData.translate('Notifications', 'الإشعارات'),
                      style: const TextStyle(
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
            // قائمة الإشعارات
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
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : _notifications.isEmpty
                          ? Center(
                              child: Text(
                                AppData.translate(
                                  'No notifications yet',
                                  'لا توجد إشعارات حالياً',
                                ),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              itemCount: _notifications.length,
                              separatorBuilder: (_, __) => const Divider(
                                  height: 1, color: Color(0xFFF0F0F0)),
                              itemBuilder: (context, index) {
                                final item = _notifications[index];
                                final isFirst = index == 0;
                                return Container(
                                  color: isFirst
                                      ? const Color(0xFFF3F6FF)
                                      : Colors.transparent,
                                  child: Stack(
                                    children: [
                                      if (isFirst)
                                        Positioned(
                                          left: AppData.isArabic ? null : 0,
                                          right: AppData.isArabic ? 0 : null,
                                          top: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 5,
                                            color: const Color(0xA3237D8C),
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 15, 20, 15),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _titleOf(item),
                                                    style: const TextStyle(
                                                      color: Color(0xFF237D8C),
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: 'Lato',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    _bodyOf(item),
                                                    style: const TextStyle(
                                                      color: Color(0xFF677191),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Lato',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    _timeAgo(item.createdAt),
                                                    style: const TextStyle(
                                                      color: Color(0xFF9BA3BB),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            // أيقونة الصح للحذف النهائي
                                            GestureDetector(
                                              onTap: () =>
                                                  _removeNotification(index),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Colors.green
                                                      .withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
