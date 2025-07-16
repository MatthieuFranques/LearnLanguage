import 'package:flutter/material.dart';
import 'package:learn_language/class/word.dart';
import 'package:learn_language/vocabulary/vocabularyQuiz.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _englishController = TextEditingController();
  final TextEditingController _frenchController = TextEditingController();

  void _addWord() {
    final english = _englishController.text.trim();
    final french = _frenchController.text.trim();
    if (english.isNotEmpty && french.isNotEmpty) {
      // Word.instance.addWord(english, french);
      // _englishController.clear();
      // _frenchController.clear();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Mot ajouté au quiz !')),
      // );
    }
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
              decoration: const InputDecoration(
                labelText: 'Définition en français',
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
