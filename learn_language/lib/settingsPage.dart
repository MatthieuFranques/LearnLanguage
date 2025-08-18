import 'package:flutter/material.dart';
import 'package:learn_language/components/customAppBar.dart';
import 'package:learn_language/theme/appColor.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

 Widget build(BuildContext context) {
  return const Scaffold(
    appBar: CustomAppBar(title: 'Paramètres', showBackButton: false),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.build, size: 64, color: AppColors.textDisabled),
          SizedBox(height: 12),
          Text(
        "Paramètres non disponible",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
        SizedBox(height: 8),
          Text(
            'Cette section est en cours de développement',
            style: TextStyle(fontSize: 16, color: AppColors.textDisabled),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
}
