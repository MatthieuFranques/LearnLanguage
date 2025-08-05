import 'package:flutter/material.dart';
import 'package:learn_language/historyPage.dart';
import 'package:learn_language/homePage.dart';
import 'package:learn_language/settingsPage.dart';
import 'package:learn_language/theme/appColor.dart';
import 'package:learn_language/toolsPage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

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
        removeBottom: true, // enlève le padding système en bas (safe area)
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
                  color: AppColors.primary,
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.secondary.withOpacity(0.5)
                                  : Colors.transparent,
                            ),
                            child: Icon(
                              _icons[index],
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textHint,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _labels[index],
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textHint,
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

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 60);
    path.quadraticBezierTo(
      size.width / 2,
      -40,
      size.width,
      60,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
