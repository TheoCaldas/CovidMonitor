import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService notificationService =
      NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return notificationService;
  }

  NotificationService._internal();

  static const channel_id = "12345";

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    tz.initializeTimeZones(); // <------

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String? payload) async {}

  Future<void> showNotification(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
        12345,
        title,
        body,
        NotificationDetails(
            iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        )),
        payload: 'data');
  }

  Future<void> scheduleNotificationDaysFromNow(
      DateTime date, int days, String title, String body) async {
    final dateTimeZone = tz.TZDateTime.from(date, tz.local);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        12345,
        title,
        body,
        dateTimeZone.add(Duration(days: days)),
        const NotificationDetails(
            iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        )),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  Future<void> scheduleThirdDose(DateTime fromDate) async {
    final title = "3a Dose da Vacina Contra o Covid-19";
    final body =
        "Já está na hora de você tomar a terceira dose! Corra para o posto de saúde mais próximo.";
    final days = 90;
    final finalDay = fromDate.add(Duration(days: days));
    if (finalDay.difference(DateTime.now()).inDays > 0) {
      await scheduleNotificationDaysFromNow(
        fromDate,
        90,
        title,
        body,
      );
    } else {
      showNotification(title, body);
    }
  }

  void cancelNotificationForDate() async {
    //await flutterLocalNotificationsPlugin.cancel(birthday.hashCode);
  }

  Future<bool> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    return true;
  }

  void handleApplicationWasLaunchedFromNotification(String payload) async {
    if (Platform.isIOS) {
      _rescheduleNotificationFromPayload(payload);
      return;
    }

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {
      _rescheduleNotificationFromPayload(
          notificationAppLaunchDetails.payload ?? "");
    }
  }

  Future<bool> _wasApplicationLaunchedFromNotification() async {
    NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null) {
      return notificationAppLaunchDetails.didNotificationLaunchApp;
    }

    return false;
  }

  void _rescheduleNotificationFromPayload(String payload) {}
}
