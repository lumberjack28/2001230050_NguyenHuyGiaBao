import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  Notifications._();
  static final Notifications instance = Notifications._();

  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static int _lastId = 100;
  static int newId() {
    final proposed = DateTime.now().microsecondsSinceEpoch.remainder(2000000000);
    _lastId = proposed > _lastId ? proposed : _lastId + 1;
    return _lastId;
  }

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await plugin.initialize(const InitializationSettings(android: android));
    final implementation = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await implementation?.requestNotificationsPermission();
  }

  NotificationDetails _details(String channel) => NotificationDetails(
        android: AndroidNotificationDetails(
          channel,
          channel == 'vocab' ? 'Hoc tu vung' : 'Nhac viec',
          channelDescription: 'Thong bao bai thuc hanh Flutter',
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

  Future<void> show(String title, String message,
      {String channel = 'todo'}) async {
    await plugin.show(newId(), title, message, _details(channel));
  }

  // Returns true when exact alarms were permitted, false if an inexact
  // schedule had to be used instead.
  Future<bool> schedule({
    required int id,
    required String title,
    required String message,
    required DateTime when,
    String channel = 'todo',
    String? payload,
  }) async {
    if (!when.isAfter(DateTime.now())) {
      throw ArgumentError('Thoi gian nhac phai o tuong lai');
    }

    bool exact = false;
    final implementation = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    try {
      exact = (await implementation?.requestExactAlarmsPermission()) == true;
    } catch (_) {
      exact = false;
    }

    await plugin.zonedSchedule(
      id,
      title,
      message,
      tz.TZDateTime.from(when, tz.local),
      _details(channel),
      payload: payload,
      androidScheduleMode: exact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );
    return exact;
  }

  Future<List<PendingNotificationRequest>> pendingVocabulary() async {
    final all = await plugin.pendingNotificationRequests();
    return all.where((item) => item.payload?.startsWith('vocab:') == true).toList();
  }

  Future<void> cancel(int id) => plugin.cancel(id);
}
