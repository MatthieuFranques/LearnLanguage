import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:learn_language/components/layout/mainNavigation.dart';
import 'package:learn_language/services/notification/notification.dart';
import 'package:learn_language/theme/appColor.dart';
import 'package:learn_language/theme/themeData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Navigation bar customization
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.primaryDark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

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
    NotificationService.showAddWordNotification();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const MainNavigation(),
    );
  }
}
