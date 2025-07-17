import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learn_language/services/api/apiTranslate.dart';
import 'package:learn_language/models/word.dart';
import 'package:learn_language/services/pickImage.dart';
import 'package:learn_language/services/wordSelectionDialog.dart';
import 'package:learn_language/services/words/wordStorage.dart';
import 'package:learn_language/vocabulary/vocabularyQuiz.dart';

class HomePage extends StatefulWidget {
  final bool openAddWord;

  const HomePage({Key? key, this.openAddWord = false}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _englishController = TextEditingController();
  final TextEditingController _frenchController = TextEditingController();
  Timer? _debounce;

  bool isEnglishToFrench = true; // 🔁 sens de traduction

  @override
  void initState() {
    super.initState();
    _englishController.addListener(_onEnglishChanged);
    _frenchController.addListener(_onFrenchChanged);
  }

  @override
  void dispose() {
    _englishController.removeListener(_onEnglishChanged);
    _frenchController.removeListener(_onFrenchChanged);
    _englishController.dispose();
    _frenchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onEnglishChanged() {
    if (!isEnglishToFrench) return; // ignorer si on est en FR ➜ EN

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final english = _englishController.text.trim();
      if (english.isNotEmpty) {
        _translateWord();
      } else {
        setState(() {
          _frenchController.text = '';
        });
      }
    });
  }

  void _onFrenchChanged() {
    if (isEnglishToFrench) return; // ignorer si on est en EN ➜ FR

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final french = _frenchController.text.trim();
      if (french.isNotEmpty) {
        _translateWord();
      } else {
        setState(() {
          _englishController.text = '';
        });
      }
    });
  }

  Future<void> _translateWord() async {
    try {
      if (isEnglishToFrench) {
        final translation =
            await translateToFrench(_englishController.text.trim());
        setState(() {
          _frenchController.text = translation;
        });
      } else {
        final translation =
            await translateToEnglish(_frenchController.text.trim());
        setState(() {
          _englishController.text = translation;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur de traduction')),
      );
    }
  }

  Future<void> _addWord() async {
    final english = _englishController.text.trim();
    final french = _frenchController.text.trim();

    if (english.isNotEmpty && french.isNotEmpty) {
      final word = Word(english, french);
      await WordStorage.addWord(word);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mot ajouté !')),
      );

      _englishController.clear();
      _frenchController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir les deux champs')),
      );
    }
  }

  void _toggleDirection() {
    setState(() {
      isEnglishToFrench = !isEnglishToFrench;
      _englishController.clear();
      _frenchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VocabularyQuiz()),
                );
              },
              child: const Text('Commencer le Quiz'),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isEnglishToFrench ? 'EN' : 'FR'),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: _toggleDirection,
                ),
                Text(isEnglishToFrench ? 'FR' : 'EN'),
              ],
            ),
            TextField(
              controller: _englishController,
              decoration: InputDecoration(
                labelText:
                    isEnglishToFrench ? 'Mot en anglais' : 'Mot en anglais',
                border: const OutlineInputBorder(),
              ),
              readOnly: !isEnglishToFrench,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _frenchController,
              decoration: InputDecoration(
                labelText: isEnglishToFrench
                    ? 'Traduction en français'
                    : 'Mot en français',
                border: const OutlineInputBorder(),
              ),
              readOnly: isEnglishToFrench,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addWord,
              child: const Text('Ajouter au quiz'),
            ),
            const SizedBox(height: 244),
            ElevatedButton.icon(
              onPressed: () async {
                final ocrResult = await pickImageAndExtractText();

                if (ocrResult != null) {
                  // Ouvre une page ou un dialog de sélection
                  showDialog(
                    context: context,
                    builder: (_) => WordSelectionDialog(
                      ocrResult: ocrResult,
                      onWordSelected: (word) {
                        _englishController.text = word;
                        _translateWord();
                      },
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Aucun texte détecté')),
                  );
                }
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scanner un mot'),
            )
          ],
        ),
      ),
    );
  }
}
