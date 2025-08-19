import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_language/components/layout/mainNavigation.dart';
import 'package:learn_language/theme/appColor.dart';
import 'package:learn_language/theme/themeData.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

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

  setFavicon('assets/icon/app_icon.png');
  runApp(const MyApp());
}

void setFavicon(String url) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final link = html.document.querySelector("link[rel*='icon']") as html.LinkElement?;
    if (link != null) {
      link.href = url + '?v=${DateTime.now().millisecondsSinceEpoch}';
    } else {
      final newLink = html.LinkElement()
        ..rel = 'icon'
        ..type = 'image/png'
        ..href = url + '?v=${DateTime.now().millisecondsSinceEpoch}';
      html.document.head!.append(newLink);
    }
  });
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
