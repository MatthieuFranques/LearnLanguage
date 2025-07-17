import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showAddWordNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'add_word_channel',
      'Add Word Notifications',
      channelDescription: 'Notifications pour ajouter un mot',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notificationsPlugin.show(
      0,
      'Nouveau mot à ajouter',
      'Clique pour ajouter un mot au quiz !',
      platformChannelSpecifics,
      payload: 'add_word',
    );
  }
}
