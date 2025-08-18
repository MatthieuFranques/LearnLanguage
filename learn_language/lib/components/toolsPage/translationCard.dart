import 'package:flutter/material.dart';
import 'package:learn_language/theme/appColor.dart';

class TranslationCard extends StatelessWidget {
  final bool isEnglishToFrench;
  final TextEditingController englishController;
  final TextEditingController frenchController;
  final VoidCallback onToggleDirection;
  final VoidCallback onAddWord;

  const TranslationCard({
    super.key,
    required this.isEnglishToFrench,
    required this.englishController,
    required this.frenchController,
    required this.onToggleDirection,
    required this.onAddWord,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: AppColors.buttonText,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: AppColors.shadow,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isEnglishToFrench ? 'EN' : 'FR',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  color: AppColors.textPrimary,
                  onPressed: onToggleDirection,
                ),
                Text(
                  isEnglishToFrench ? 'FR' : 'EN',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller:
                  isEnglishToFrench ? englishController : frenchController,
              decoration: InputDecoration(
                labelText:
                    isEnglishToFrench ? 'Mot en anglais' : 'Mot en français',
                labelStyle: const TextStyle(color: AppColors.textDisabled),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.textPrimary),
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon:
                    const Icon(Icons.language, color: AppColors.textPrimary),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              cursorColor: AppColors.textPrimary,
            ),
            const SizedBox(height: 16),
            TextField(
              controller:
                  isEnglishToFrench ? frenchController : englishController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: isEnglishToFrench
                    ? 'Traduction en français'
                    : 'Traduction en anglais',
                labelStyle: const TextStyle(color: AppColors.textDisabled),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.textPrimary),
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon:
                    const Icon(Icons.translate, color: AppColors.textPrimary),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonHover,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: onAddWord,
                child: const Text(
                  'Ajouter au quiz',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
