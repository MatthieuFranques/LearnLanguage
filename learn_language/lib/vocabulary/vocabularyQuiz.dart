import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_language/models/word.dart';

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
  bool isEnglishToFrench = true;

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
      isEnglishToFrench = Random().nextBool();
    });
  }

  void nextWord() {
    if (currentIndex < words.length - 1) {
      setState(() {
        currentIndex++;
        userAnswer = '';
        attemptCount = 0;
        isEnglishToFrench = Random().nextBool();
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (unlocked) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Quiz Quotidien'),
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            '🎉 Accès débloqué !',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    final word = words[currentIndex];
    final questionWord = isEnglishToFrench ? word.english : word.french;
    final direction = isEnglishToFrench ? 'français' : 'anglais';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Quiz Quotidien'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Mot ${currentIndex + 1} sur ${words.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Traduire en $direction',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      questionWord,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _controller,
              onChanged: (value) => userAnswer = value,
              decoration: InputDecoration(
                labelText: 'Votre réponse',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 24),
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
                onPressed: checkAnswer,
                child: const Text(
                  'Vérifier',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
