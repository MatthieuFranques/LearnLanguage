import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learn_language/services/api/apiTranslate.dart';
import 'package:learn_language/models/word.dart';
import 'package:learn_language/services/pickImage.dart';
import 'package:learn_language/services/wordSelectionDialog.dart';
import 'package:learn_language/services/words/wordStorage.dart';
import 'package:learn_language/vocabulary/vocabularyChoiceQuiz.dart';
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

  bool isEnglishToFrench = true;

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
    if (!isEnglishToFrench) return;
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
    if (isEnglishToFrench) return;
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
    _englishController.removeListener(_onEnglishChanged);
    _frenchController.removeListener(_onFrenchChanged);

    setState(() {
      isEnglishToFrench = !isEnglishToFrench;

      final temp = _englishController.text;
      _englishController.text = _frenchController.text;
      _frenchController.text = temp;
    });

    _englishController.addListener(_onEnglishChanged);
    _frenchController.addListener(_onFrenchChanged);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset(
            'assets/icon/app_icon.png',
            width: 54,
            height: 54,
          ),
          onPressed: () {
            // Ton action
          },
        ),
        title: const Text('Accueil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VocabularyQuiz()),
                  );
                },
                child: const Text(
                  'Commencer le Quiz',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VocabularyChoiceQuiz()),
                  );
                },
                child: const Text(
                  'Commencer le Quiz Multiple',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Card(
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
                          onPressed: _toggleDirection,
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
                      controller: isEnglishToFrench
                          ? _englishController
                          : _frenchController,
                      decoration: InputDecoration(
                        labelText: isEnglishToFrench
                            ? 'Mot en anglais'
                            : 'Mot en français',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: theme.primaryColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.language),
                      ),
                      readOnly: false,
                    ),
                    const SizedBox(height: 16),
                    // Champ résultat en bas
                    TextField(
                      controller: isEnglishToFrench
                          ? _frenchController
                          : _englishController,
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
                      readOnly: true,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _addWord,
                        child: const Text(
                          'Ajouter au quiz',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final ocrResult = await pickImageAndExtractText();
                  if (ocrResult != null) {
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
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text(
                  'Scanner un mot',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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
