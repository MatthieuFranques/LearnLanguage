import 'package:flutter/material.dart';

class TranslationCard extends StatelessWidget {
  final bool isEnglishToFrench;
  final TextEditingController englishController;
  final TextEditingController frenchController;
  final VoidCallback onToggleDirection;
  final VoidCallback onAddWord;
  final Color? actionButtonColor;

  const TranslationCard({
    super.key,
    required this.isEnglishToFrench,
    required this.englishController,
    required this.frenchController,
    required this.onToggleDirection,
    required this.onAddWord,
    this.actionButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  color: theme.primaryColor,
                  onPressed: onToggleDirection,
                ),
                Text(
                  isEnglishToFrench ? 'FR' : 'EN',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: isEnglishToFrench ? englishController : frenchController,
              decoration: InputDecoration(
                labelText: isEnglishToFrench ? 'Mot en anglais' : 'Mot en français',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.language),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: isEnglishToFrench ? frenchController : englishController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: isEnglishToFrench
                    ? 'Traduction en français'
                    : 'Traduction en anglais',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.translate),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: actionButtonColor ?? theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onAddWord,
                child: const Text(
                  'Ajouter au quiz',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
