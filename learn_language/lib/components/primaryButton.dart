import 'package:flutter/material.dart';
import 'package:learn_language/theme/appGradients.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double height;
  final bool disabled;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.height = 50,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
         onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
    padding: EdgeInsets.zero, 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor: Colors.transparent, 
    shadowColor: Colors.transparent, 
  ),
  child: Ink(
    decoration: BoxDecoration(
      gradient: AppGradients.primaryGradient, 
      borderRadius: BorderRadius.circular(12),
    ),
        child: Container(
      alignment: Alignment.center,
      child:  Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      ),
  ),)
    );
  }
}
