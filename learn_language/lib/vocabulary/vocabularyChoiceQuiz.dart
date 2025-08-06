import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_language/components/customAppBar.dart';
import 'package:learn_language/components/customEndDialog.dart';
import 'package:learn_language/components/footerWave.dart';
import 'package:learn_language/models/ranking.dart';
import 'package:learn_language/models/word.dart';
import 'package:learn_language/services/words/rankingStorage.dart';
import 'package:learn_language/theme/appColor.dart';

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
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    loadWords();
  }

  Future<void> loadWords() async {
    final String response = await rootBundle.loadString('assets/words.json');
    final List data = json.decode(response);

    List<Word> allWords =
        data.map((e) => Word(e['english'], e['french'])).toList();

    allWords.shuffle(); // mélange tous les mots

// Prend les 10 premiers mots après mélange
    List<Word> selectedWords = allWords.take(10).toList();

    setState(() {
      words = selectedWords;
      isLoading = false;
      isEnglishToFrench = Random().nextBool();
    });

    generateOptions();
  }

  Future<void> saveScoreOnce() async {
    await RankingStorage.addWord(
        Ranking('Quiz Multiple', correctAnswers.toString()));
    print("Sauvegarde du score dans le fichier JSON");
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
    if (currentIndex < 9) {
      // Limiter à 10 questions
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
      correctAnswers++;
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

  void showEndDialog() {
    saveScoreOnce();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomEndDialog(
        title: 'Quiz terminer',
        message: 'Tu as terminé cette session.',
        score: correctAnswers,
        onReplay: () {
          setState(() {
            words = [];
            currentIndex = 0;
            unlocked = false;
            isLoading = true;
            correctAnswers = 0;
            loadWords();
          });
        },
        onQuit: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final word = words[currentIndex];
    final question = isEnglishToFrench ? word.english : word.french;
    final direction = isEnglishToFrench ? 'français' : 'anglais';

    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (unlocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showEndDialog();
      });
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Quiz Choix'),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox.expand(
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
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Traduire en $direction',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            question,
                            style: const TextStyle(
                              fontSize: 28,
                              color: AppColors.textPrimary,
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
                      final buttonWidth =
                          (availableWidth - 16) / 2; // 16 = spacing

                      return Wrap(
                        spacing: 16, // espace horizontal entre boutons
                        runSpacing: 16, // espace vertical entre lignes
                        children: options.map((option) {
                          return SizedBox(
                            width: buttonWidth,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonHover,
                                foregroundColor: AppColors.textHint,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => checkAnswer(option),
                              child: Text(option,
                                  style: const TextStyle(fontSize: 18)),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          const FooterWave(),
        ],
      ),
    );
  }
}
