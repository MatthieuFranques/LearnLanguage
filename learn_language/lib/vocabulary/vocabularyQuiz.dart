import 'package:flutter/material.dart';
import 'package:learn_language/class/word.dart';

class VocabularyQuiz extends StatefulWidget {
  const VocabularyQuiz({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VocabularyQuizState createState() => _VocabularyQuizState();
}

class _VocabularyQuizState extends State<VocabularyQuiz> {
  final List<Word> words = [
    Word('apple', 'pomme'),
    Word('dog', 'chien'),
    Word('cat', 'chat'),
    Word('house', 'maison'),
    Word('book', 'livre'),
  ];

  int currentIndex = 0;
  String userAnswer = '';
  bool unlocked = false;

  void checkAnswer() {
    final correctAnswer = words[currentIndex].french.toLowerCase().trim();
    if (userAnswer.toLowerCase().trim() == correctAnswer) {
      if (currentIndex < words.length - 1) {
        setState(() {
          currentIndex++;
          userAnswer = '';
        });
      } else {
        setState(() {
          unlocked = true;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mauvaise réponse, réessayez !')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Quotidien')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Traduire en français : ${word.english}',
              style: const TextStyle(fontSize: 24),
            ),
            TextField(
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
