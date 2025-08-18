import 'dart:io';
import 'package:flutter/material.dart';
import 'package:learn_language/services/pickImage.dart';

class WordSelectionDialog extends StatelessWidget {
  final OCRResult ocrResult;
  final void Function(String) onWordSelected;

  const WordSelectionDialog({
    super.key,
    required this.ocrResult,
    required this.onWordSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 600, // Limite la hauteur max
          maxWidth: 500, // Limite la largeur max
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Texte détecté',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.file(
                          File(ocrResult.imagePath),
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        ocrResult.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fermer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
