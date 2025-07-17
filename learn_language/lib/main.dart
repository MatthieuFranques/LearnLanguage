import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:learn_language/homePage.dart';
import 'package:learn_language/notification/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initNotification();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool openAddWord = false;

  @override
  void initState() {
    super.initState();

    // Vérifie si l'appli est lancée par une notif
    NotificationService.notificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((details) {
      if (details?.didNotificationLaunchApp ?? false) {
        final payload = details!.notificationResponse?.payload;
        if (payload == 'add_word') {
          setState(() {
            openAddWord = true;
          });
        }
      }
    });

    // Écoute les notifications quand l'app est déjà ouverte
    NotificationService.notificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (details) {
        if (details.payload == 'add_word') {
          setState(() {
            openAddWord = true;
          });
        }
      },
    );

    // 🔔
    NotificationService.notificationsPlugin.periodicallyShow(
      0,
      'Nouveau mot ?',
      'Clique ici pour ajouter un mot au quiz !',
      RepeatInterval.hourly,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'add_word_channel',
          'Add Word Notifications',
          channelDescription: 'Notifications pour ajouter un mot au quiz',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      // androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'add_word',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dictionnaire Quiz',
      home: HomePage(openAddWord: openAddWord),
    );
  }
}
