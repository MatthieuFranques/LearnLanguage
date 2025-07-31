import 'package:flutter/material.dart';
import 'package:learn_language/components/primaryIconButton.dart';
import 'package:learn_language/components/translationCard.dart';
import 'package:learn_language/controllers/homePageController.dart';
import 'package:learn_language/services/pickImage.dart';
import 'package:learn_language/services/wordSelectionDialog.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});
  @override
  State<TranslatePage> createState() => _HomePageState();
}

class _HomePageState extends State<TranslatePage> {
  final HomePageController _controller = HomePageController();

  @override
  void initState() {
    super.initState();

    _controller.englishController.addListener(() {
      _controller.onEnglishChanged(
        _translateWord,
        () => setState(() => _controller.frenchController.text = ''),
      );
    });

    _controller.frenchController.addListener(() {
      _controller.onFrenchChanged(
        _translateWord,
        () => setState(() => _controller.englishController.text = ''),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _translateWord() async {
    final translation = await _controller.translateWord();
    if (translation != null) {
      setState(() {
        if (_controller.isEnglishToFrench) {
          _controller.frenchController.text = translation;
        } else {
          _controller.englishController.text = translation;
        }
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur de traduction')),
      );
    }
  }

  void _toggleDirection() {
    setState(() {
      _controller.toggleDirection();
    });
  }

  Future<void> _addWord() async {
    final success = await _controller.addWord();
    if (success) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mot ajouté !')),
      );
      setState(() {}); // pour rafraîchir si besoin
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir les deux champs')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);

    return Column(
          children: [
            TranslationCard(
              isEnglishToFrench: _controller.isEnglishToFrench,
              englishController: _controller.englishController,
              frenchController: _controller.frenchController,
              onToggleDirection: _toggleDirection,
              onAddWord: _addWord,
              actionButtonColor: theme.colorScheme.secondary,
            ),
            const SizedBox(height: 32),
            PrimaryIconButton(
              text: 'Scanner un mot',
              icon: Icons.camera_alt,
              onPressed: () async {
                final ocrResult = await pickImageAndExtractText();
                if (ocrResult != null) {
                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (_) => WordSelectionDialog(
                      ocrResult: ocrResult,
                      onWordSelected: (word) {
                        setState(() {
                          _controller.englishController.text = word;
                        });
                        _translateWord();
                      },
                    ),
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Aucun texte détecté')),
                  );
                }
              },
            ),
          ]
    );
  }
}