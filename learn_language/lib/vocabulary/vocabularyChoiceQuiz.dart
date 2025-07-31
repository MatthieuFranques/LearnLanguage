import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_language/models/word.dart';

class VocabularyChoiceQuiz extends StatefulWidget {
  const VocabularyChoiceQuiz({super.key});

  @override
  State<VocabularyChoiceQuiz> createState() => _VocabularyChoiceQuizState();
}

class _VocabularyChoiceQuizState extends State<VocabularyChoiceQuiz> {
  List<Word> words = [];
  int currentIndex = 0;
  String userAnswer = '';
  bool unlocked = false;
  bool isLoading = true;
  int attemptCount = 0;
  late TextEditingController _controller;
  bool isEnglishToFrench = true;
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    loadWords();
  }

  Future<void> loadWords() async {
    final String response = await rootBundle.loadString('assets/words.json');
    final List data = json.decode(response);

    // Charge un grand nombre de mots (par exemple 50 ou 100)
    List<Word> loadedWords = data.map((e) => Word(e['english'], e['french'])).toList();

    setState(() {
      words = loadedWords;
      isLoading = false;
      isEnglishToFrench = Random().nextBool();
    });

    generateOptions();
  }

  void generateOptions() {
  if (words.isEmpty) return;

  final correct = isEnglishToFrench
      ? words[currentIndex].french
      : words[currentIndex].english;

  final Set<String> optionSet = {correct};

  // Ajoute jusqu'à 3 mauvaises réponses différentes
  while (optionSet.length < 4) {
    final randomWord = words[Random().nextInt(words.length)];
    final wrong = isEnglishToFrench ? randomWord.french : randomWord.english;

    if (wrong != correct) {
      optionSet.add(wrong);
    }
  }
  // Mélange les options
  options = optionSet.toList()..shuffle();
}

  void nextWord() {
    if (currentIndex < 9) { // Limiter à 10 questions
      setState(() {
        currentIndex++;
        userAnswer = '';
        attemptCount = 0;
        isEnglishToFrench = Random().nextBool();
        _controller.clear();
      });
      generateOptions();
    } else {
      setState(() {
        unlocked = true;
      });
    }
  }

  void checkAnswer(String answer) {
    final word = words[currentIndex];
    final correct = isEnglishToFrench ? word.french : word.english;

    if (answer.toLowerCase().trim() == correct.toLowerCase().trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Bonne réponse !')),
      );
      Future.delayed(const Duration(milliseconds: 500), nextWord);
    } else {
      attemptCount++;
      if (attemptCount >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Réponse correcte : $correct')),
        );
        Future.delayed(const Duration(milliseconds: 500), nextWord);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mauvaise réponse, réessayez !')),
        );
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
    final theme = Theme.of(context);

    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (unlocked) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Quiz Terminé'),
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            '🎉 Bravo, quiz terminé !',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final word = words[currentIndex];
    final question = isEnglishToFrench ? word.english : word.french;
    final direction = isEnglishToFrench ? 'français' : 'anglais';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Quiz Choix'),
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
                  children: [
                    Text(
                    'Mot ${currentIndex + 1} / 10',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 16),
                    Text(
                      'Traduire en $direction',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      question,
                      style: TextStyle(
                        fontSize: 28,
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),      
            LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final buttonWidth = (availableWidth - 16) / 2; // 16 = spacing

              return Wrap(
                spacing: 16, // espace horizontal entre boutons
                runSpacing: 16, // espace vertical entre lignes
                children: options.map((option) {
                  return SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => checkAnswer(option),
                      child: Text(option, style: const TextStyle(fontSize: 18)),
                    ),
                  );
                }).toList(),
              );
            },
          )
          ],
        ),
      ),
    );
  }
}
