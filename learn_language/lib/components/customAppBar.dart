import 'package:flutter/material.dart';
import 'package:learn_language/theme/apColor.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fond lavande avec arc vers le bas (concave)
        ClipPath(
          clipper: InvertedCurveClipper(),
          child: Container(
            height: preferredSize.height,
            color: AppColors.primary, // Utilise la couleur primaire
          ),
        ),
        // Titre centré
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ClipPath avec arc inversé
class InvertedCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height); // gauche-bas
    path.quadraticBezierTo(
      size.width / 2,
      size.height - 200, // Point le plus haut de l'arc
      size.width,
      size.height,
    );
    path.lineTo(size.width, 0); // haut-droit
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
