import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_language/components/customAppBar.dart';
import 'package:learn_language/components/customEndDialog.dart';
import 'package:learn_language/components/footerWave.dart';
import 'package:learn_language/components/primaryButton.dart';
import 'package:learn_language/models/ranking.dart';
import 'package:learn_language/models/word.dart';
import 'package:learn_language/services/words/rankingStorage.dart';
import 'package:learn_language/theme/appColor.dart';

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
  int correctAnswers = 0;
  bool _scoreSaved = false;
  int numberWords = 10;

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
    loadedWords = loadedWords.take(numberWords).toList();

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

  Future<void> saveScoreOnce() async {
    if (!_scoreSaved) {
      _scoreSaved = true;
      await RankingStorage.addWord(Ranking('Quiz', correctAnswers.toString()));
      print("Sauvegarde du score dans le fichier JSON");
    }
  }

  void checkAnswer() {
    final word = words[currentIndex];
    final correctAnswer = isEnglishToFrench
        ? word.french.toLowerCase().trim()
        : word.english.toLowerCase().trim();

    if (userAnswer.toLowerCase().trim() == correctAnswer) {
      correctAnswers++;
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

  void showEndDialog() {
    saveScoreOnce();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomEndDialog(
        title: 'Quiz terminer',
        message: 'Tu as trouvé  $correctAnswers / $numberWords mots',        
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

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (unlocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showEndDialog();
      });
    }

    final word = words[currentIndex];
    final questionWord = isEnglishToFrench ? word.english : word.french;
    final direction = isEnglishToFrench ? 'français' : 'anglais';

    return Scaffold(
      appBar: const CustomAppBar(title: 'Quiz Quotidien'),
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0,
                -0.5), // centré horizontalement, un peu plus haut verticalement
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // centre verticalement
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
                                fontWeight: FontWeight.bold, color: AppColors.textPrimary
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Traduire en $direction',
                              style: const TextStyle(
                                fontSize: 20,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              questionWord,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 72),
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
                    PrimaryButton(text: 'Vérifier', onPressed: checkAnswer),
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
