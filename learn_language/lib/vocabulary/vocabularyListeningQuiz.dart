import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learn_language/components/customAppBar.dart';
import 'package:learn_language/components/footerWave.dart';
import 'package:learn_language/components/primaryButton.dart';
import 'package:learn_language/models/ranking.dart';
import 'package:learn_language/services/words/rankingStorage.dart';
import 'package:learn_language/theme/appColor.dart';
import 'package:learn_language/theme/appGradients.dart';

class VocabularyListeningQuiz extends StatefulWidget {
  const VocabularyListeningQuiz({super.key});

  @override
  State<VocabularyListeningQuiz> createState() =>
      _VocabularyListeningQuizState();
}

class _VocabularyListeningQuizState extends State<VocabularyListeningQuiz> {
  final FlutterTts _tts = FlutterTts();
  List<Map<String, String>> words = [];
  int currentIndex = 0;
  bool isEnglishToFrench = true;
  bool _answered = false;
  int _attemptCount = 0;
  bool _unlocked = false;

  late String _correctAnswer;
  late List<String> _options;
  late String _wordToListen;

  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  Future<void> loadWords() async {
    final String response = await rootBundle.loadString('assets/words.json');
    final List data = json.decode(response);

    words = data
        .map<Map<String, String>>((e) => {
              'english': e['english'] as String,
              'french': e['french'] as String,
            })
        .toList();

    words.shuffle();

    prepareQuestion();
  }

  void prepareQuestion() {
    if (currentIndex >= 10 || currentIndex >= words.length) {
      setState(() {
        _unlocked = true;
      });
      return;
    }

    setState(() {
      _answered = false;
      _attemptCount = 0;

      final currentWord = words[currentIndex];
      _wordToListen = currentWord['english']!;
      _correctAnswer = currentWord['english']!;

      // Générer les options uniquement en anglais
      final optionsSet = <String>{_correctAnswer};
      final rand = Random();

      while (optionsSet.length < 4) {
        final randomWord = words[rand.nextInt(words.length)];
        optionsSet.add(randomWord['english']!);
      }
      _options = optionsSet.toList()..shuffle();
    });

    speakWord();
  }

  Future<void> speakWord() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.speak(_wordToListen);
  }

  void checkAnswer(String selected) {
    if (_answered) return;

    setState(() {
      _attemptCount++;
      if (selected.toLowerCase() == _correctAnswer.toLowerCase()) {
        _answered = true;
        correctAnswers++;
        _tts.speak('Correct!');
      } else {
        if (_attemptCount >= 3) {
          _answered = true;
          _tts.speak('The correct answer was $_correctAnswer');
        } else {
          _tts.speak('Incorrect, try again');
        }
      }
    });

    if (_answered) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          currentIndex++;
        });
        prepareQuestion();
      });
    }
  }

  Future<void> saveScoreOnce() async {
    await RankingStorage.addWord(
        Ranking('Compréhension', correctAnswers.toString()));
    print("Sauvegarde du score dans le fichier JSON");
  }

  void showEndDialog() {
    saveScoreOnce();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Quiz terminé'),
        content: Text('Tu as obtenu $correctAnswers sur 10 bonnes réponses.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                currentIndex = 0;
                correctAnswers = 0;
                _unlocked = false;
                words.shuffle();
              });
              prepareQuestion();
            },
            child: const Text('Rejouer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (words.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_unlocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showEndDialog());
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Quiz de vocabulaire audio'),
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0,
                -0.5), // centré horizontalement, un peu plus haut verticalement
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(
                              'Mot ${currentIndex + 1} / 10',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Écoute le mot et choisis la bonne traduction',
                              style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: speakWord,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                                decoration: BoxDecoration(
                                  gradient: AppGradients.primaryGradientTop,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.volume_up,
                                  size: 32,
                                  color: AppColors.card, 
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 72),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final availableWidth = constraints.maxWidth;
                        const spacing = 16.0;
                        final buttonWidth = (availableWidth - spacing) / 2;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: _options.map((option) {
                          bool disabled = false;
                          Gradient gradient = AppGradients.primaryGradient;

                          // Gestion des états après réponse
                          if (_answered) {
                            if (option == _correctAnswer) {
                              gradient = AppGradients.successGradient; // bouton vert
                            } else if (_attemptCount > 0 && option != _correctAnswer) {
                              gradient = AppGradients.primaryGradient; // gradient normal
                            } else {
                              gradient = AppGradients.errorGradient; // bouton rouge
                              disabled = true;
                            }
                          }
                          return SizedBox(
                            width: buttonWidth,
                            child: PrimaryButton(
                              text: option,
                              onPressed: _answered ? null : () => checkAnswer(option),
                              disabled: disabled,
                            ),
                          );
                        }).toList(),
                      );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const FooterWave(),
        ],
      ),
    );
  }
}
