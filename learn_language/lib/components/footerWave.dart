import 'package:flutter/material.dart';
import 'package:learn_language/theme/appColor.dart';

class FooterWave extends StatelessWidget {
  const FooterWave({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipPath(
        clipper: BottomCurveClipper(),
        child: Container(
          height: 100,
          color: AppColors.primary,
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
