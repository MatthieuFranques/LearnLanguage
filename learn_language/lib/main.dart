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

  // Changer le favicon Web dynamiquement
  setFavicon('assets/icon/app_icon.png');

  runApp(const MyApp());
}

void setFavicon(String url) {
  final link = html.document.querySelector("link[rel*='icon']") ?? html.LinkElement();
  link.setAttribute('type', 'image/png');
  link.setAttribute('rel', 'icon');
  link.setAttribute('href', url + '?v=1');
  html.document.head!.append(link);
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
