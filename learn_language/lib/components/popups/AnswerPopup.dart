import 'package:flutter/material.dart';
import 'package:learn_language/components/buttons/primaryButton.dart';
import 'package:learn_language/theme/appColor.dart';
import 'package:learn_language/theme/appGradients.dart';

class AnswerPopup {
  static void show(
    BuildContext context, {
    required bool isCorrect,
    required String correctAnswer,
    required VoidCallback onContinue,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min, // <-- ne prend que l'espace nécessaire
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? AppColors.success : AppColors.error,
                    size: 36,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isCorrect
                          ? 'Bonne réponse !'
                          : 'Mauvaise réponse ! La bonne réponse est : $correctAnswer',
                      style: TextStyle(
                        color: isCorrect ? AppColors.success : AppColors.error,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 62),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Suivant',
                  onPressed: () {
                    Navigator.pop(context);
                    onContinue();
                  },
                  height: 50,
                  gradient: isCorrect ? AppGradients.successGradient  :  AppGradients.errorGradient,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
