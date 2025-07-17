import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learn_language/api/apiTranslate.dart';
import 'package:learn_language/class/word.dart';
import 'package:learn_language/class/wordStorage.dart';
import 'package:learn_language/vocabulary/vocabularyQuiz.dart';

class HomePage extends StatefulWidget {
  final bool openAddWord; // 👈 Nouveau : pour ouvrir le popup au démarrage

  const HomePage({Key? key, this.openAddWord = false}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _englishController = TextEditingController();
  final TextEditingController _frenchController = TextEditingController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _englishController.addListener(_onEnglishChanged);

    // 👇 Si lancé depuis une notif
    if (widget.openAddWord) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddWordDialog();
      });
    }
  }

  @override
  void dispose() {
    _englishController.removeListener(_onEnglishChanged);
    _englishController.dispose();
    _frenchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onEnglishChanged() {
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

  Future<void> _translateWord() async {
    final english = _englishController.text.trim();
    if (english.isEmpty) return;

    try {
      final translation = await translateToFrench(english);
      setState(() {
        _frenchController.text = translation;
      });
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
    }
  }

  // 👇 Nouveau : Ouvre le Dialog pour ajouter un mot, même hors page
  void _showAddWordDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Ajouter un mot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _englishController,
                decoration: const InputDecoration(
                  labelText: 'Mot en anglais',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _frenchController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Traduction',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                _addWord();
                Navigator.of(context).pop();
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learn Language Home')),
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
            TextField(
              controller: _englishController,
              decoration: const InputDecoration(
                labelText: 'Mot en anglais',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _frenchController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Traduction en français',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addWord,
              child: const Text('Ajouter au quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
