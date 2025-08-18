import 'package:flutter/material.dart';
import 'package:learn_language/theme/appColor.dart';
import 'package:learn_language/theme/appGradients.dart';

class CustomEndDialog extends StatelessWidget {
  final String title;
  final String message;
  final int? score; // Optionnel
  final String? replayText;
  final String? quitText;
  final VoidCallback onReplay;
  final VoidCallback onQuit;

  const CustomEndDialog({
    Key? key,
    required this.title,
    required this.message,
    this.score,
    this.replayText = 'Rejouer',
    this.quitText = 'Quitter',
    required this.onReplay,
    required this.onQuit,
  }) : super(key: key);

  @override
Widget build(BuildContext context) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // coins arrondis
    ),
    backgroundColor: AppColors.background, // fond adapté à ton thème
    title: Row(
      children: [
        const Icon(Icons.emoji_events, color: AppColors.primary, size: 34),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 27,
                fontWeight: FontWeight.w800,
              ),
          ),
        ),
      ],
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textDisabled,
          ),
        ),
        if (score != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: RichText(
          text: TextSpan(
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 24,fontWeight: FontWeight.bold ),
            children: [
              TextSpan(text: '+ $score point${score! > 1 ? 's' : ''}  '),
              const WidgetSpan(
                child: Icon(Icons.star, color: AppColors.success, size: 28),
              ),
            ],
  ),
)
          ),
      ],
    ),
    actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    actions: [
      TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onQuit,
        child: Text(
          quitText ?? 'Quitter',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      Container(
  decoration: BoxDecoration(
    gradient: AppGradients.primaryGradient, 
    borderRadius: BorderRadius.circular(12),
  ),
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent, 
      shadowColor: Colors.transparent, 
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
      onReplay();
    },
    child: Text(
      replayText ?? 'Rejouer',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  ),
)
    ],
  );
}
}