import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_language/class/word.dart';

class VocabularyQuiz extends StatefulWidget {
  const VocabularyQuiz({super.key});

  @override
  _VocabularyQuizState createState() => _VocabularyQuizState();
}

class _VocabularyQuizState extends State<VocabularyQuiz> {
  List<Word> words = [];
  int currentIndex = 0;
  String userAnswer = '';
  bool unlocked = false;
  bool isLoading = true;
  int attemptCount = 0;
  late TextEditingController _controller;
  bool isEnglishToFrench = true; // sens de traduction

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    loadWords();
  }

  Future<void> loadWords() async {
    final String response = await rootBundle.loadString('assets/words.json');
    final List data = json.decode(response);

    List<Word> loadedWords =
        data.map((e) => Word(e['english'], e['french'])).toList();

    loadedWords.shuffle(Random());
    loadedWords = loadedWords.take(10).toList();

    setState(() {
      words = loadedWords;
      isLoading = false;
      // Choisis le sens pour le premier mot
      isEnglishToFrench = Random().nextBool();
    });
  }

  void nextWord() {
    if (currentIndex < words.length - 1) {
      setState(() {
        currentIndex++;
        userAnswer = '';
        attemptCount = 0;
        isEnglishToFrench = Random().nextBool(); // nouveau sens aléatoire
        _controller.clear();
      });
    } else {
      setState(() {
        unlocked = true;
      });
    }
  }

  void checkAnswer() {
    final word = words[currentIndex];
    final correctAnswer = isEnglishToFrench
        ? word.french.toLowerCase().trim()
        : word.english.toLowerCase().trim();

    if (userAnswer.toLowerCase().trim() == correctAnswer) {
      nextWord();
    } else {
      attemptCount++;
      if (attemptCount >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Réponse : $correctAnswer')),
        );
        nextWord();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mauvaise réponse, réessayez !')),
        );
        _controller.clear();
        userAnswer = '';
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (unlocked) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dictionnaire')),
        body: const Center(
          child: Text(
            'Accès débloqué ! 🎉',
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
    }

    final word = words[currentIndex];
    final questionWord = isEnglishToFrench ? word.english : word.french;
    final direction = isEnglishToFrench ? 'français' : 'anglais';

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Quotidien')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Mot ${currentIndex + 1} sur ${words.length}\n'
              'Traduire en $direction : $questionWord',
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            TextField(
              controller: _controller,
              onChanged: (value) => userAnswer = value,
              decoration: const InputDecoration(labelText: 'Réponse'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkAnswer,
              child: const Text('Vérifier'),
            ),
          ],
        ),
      ),
    );
  }
}
