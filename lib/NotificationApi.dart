import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi {
  static final notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "channel id",
        "channel name",
        "channel description",
        icon: "launch_background",

        importance: Importance.max
      ),
        iOS: IOSNotificationDetails(),

    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async => notifications.show(id, title, body, await _notificationDetails(), payload: payload);

  static void showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledTime,

  }) async {
    /*_notifications.zonedSchedule(id, title, body, tz.TZDateTime.from(scheduledTime, tz.local), await _notificationDetails(), payload: payload, androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);*/
    notifications.schedule(id, title, body, scheduledTime, await _notificationDetails());
    //print(notifications.pendingNotificationRequests());

    //_notifications.periodicallyShow(id, title, body, repeatInterval, await _notificationDetails());
    //print("Whats done is done!");
  }

}