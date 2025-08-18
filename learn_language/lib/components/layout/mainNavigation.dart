import 'package:flutter/material.dart';
import 'package:learn_language/components/layout/footerWave.dart';
import 'package:learn_language/pages/historyPage.dart';
import 'package:learn_language/pages/homePage.dart';
import 'package:learn_language/pages/settingsPage.dart';
import 'package:learn_language/theme/appColor.dart';
import 'package:learn_language/pages/toolsPage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    const ToolsPage(),
    const HistoryPage(),
    const SettingsPage(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.toll_outlined,
    Icons.history,
    Icons.settings,
  ];

  final List<String> _labels = [
    'Accueil',
    'Outils',
    'Historique',
    'Paramètres',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeBottom: true, 
        child: SizedBox(
          height: 120,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_pages.length, (index) {
                    final isSelected = _currentIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _currentIndex = index),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              _icons[index],
                              color: isSelected
                                  ? AppColors.textcolorBg
                                  : AppColors.secondary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _labels[index],
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? AppColors.textcolorBg
                                  : AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
