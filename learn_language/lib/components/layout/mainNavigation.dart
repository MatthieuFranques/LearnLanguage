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
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    if (isDesktop) {
      return _buildDesktopLayout();
    }
    return _buildMobileLayout(context);
  }

  // ── DESKTOP ────────────────────────────────────────────────────────────────

  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Rail latéral
          Container(
            width: 200,
            color: AppColors.primaryDark,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  // Logo / titre app
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'LearnLang',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Items de navigation
                  ...List.generate(_pages.length, (index) {
                    final isSelected = _currentIndex == index;
                    return _SideNavItem(
                      icon: _icons[index],
                      label: _labels[index],
                      isSelected: isSelected,
                      onTap: () => setState(() => _currentIndex = index),
                    );
                  }),
                ],
              ),
            ),
          ),
          // Séparateur
          const VerticalDivider(thickness: 1, width: 1),
          // Contenu principal centré avec largeur max
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),
    );
  }

  // ── MOBILE (votre layout original intact) ─────────────────────────────────

  Widget _buildMobileLayout(BuildContext context) {
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

// ── Widget item du rail latéral ────────────────────────────────────────────

class _SideNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SideNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.textcolorBg.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.textcolorBg : AppColors.secondary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.textcolorBg : AppColors.secondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
