import 'package:flutter/material.dart';
import 'package:learn_language/components/customAppBar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(title: 'Paramètres', showBackButton: false),
        backgroundColor: Colors.white,
        body: Center(child: Text('⚙️ Paramètres')));
  }
}
