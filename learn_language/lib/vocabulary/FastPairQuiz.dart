import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_language/components/customEndDialog.dart';
import 'package:learn_language/homePage.dart';
import 'package:learn_language/models/ranking.dart';
import 'package:learn_language/models/word.dart';
import 'package:learn_language/services/words/rankingStorage.dart';

class FastPairQuiz extends StatefulWidget {
  const FastPairQuiz({super.key});

  @override
  State<FastPairQuiz> createState() => _FastPairQuizState();
}

class _FastPairQuizState extends State<FastPairQuiz> {
  List<Word> words = [];
  List<Word> currentPairs = [];
  List<String> frenchWords = [];
  List<String> englishWords = [];
  Map<String, String> correctMap = {}; // français -> anglais

  String? selectedWord;
  bool selectingFrench = true;

  Set<String> matched = {};
  Set<String> wrong = {};
  int score = 0;


  bool isLoading = true;

  // Chronomètre
  static const int gameDuration = 60; // en secondes
  int timeLeft = gameDuration;
  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  Future<void> loadWords() async {
    final String response = await rootBundle.loadString('assets/words.json');
    final List data = json.decode(response);
    final loaded = data.map((e) => Word(e['english'], e['french'])).toList();

    setState(() {
      words = loaded;
      isLoading = false;
    });

    generatePairs();
    startTimer();
  }

  void generatePairs() {
    currentPairs = [...words]..shuffle();
    currentPairs = currentPairs.take(4).toList();

    frenchWords = currentPairs.map((e) => e.french).toList()..shuffle();
    englishWords = currentPairs.map((e) => e.english).toList()..shuffle();

    correctMap = {
      for (var w in currentPairs) w.french: w.english,
    };

    selectedWord = null;
    matched.clear();
    wrong.clear();
    setState(() {});
  }

  void startTimer() {
  gameTimer?.cancel();
  timeLeft = gameDuration;
  score = 0;
  matched.clear();
  gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (timeLeft <= 1) {
      timer.cancel();
      showEndDialog();
    }
    setState(() {
      timeLeft--;
    });
  });
}

void showEndDialog() {
  saveScoreOnce();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomEndDialog(
      title: '⏰ Temps écoulé',
      message: 'Tu as terminé cette session.',
      score: score,
      onReplay: () {
        generatePairs();
        startTimer();
      },
      onQuit: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      },
    ),
  );
}

  Future<void> saveScoreOnce() async { 
    await RankingStorage.addWord(
      Ranking('Quiz de rapidité', score.toString())
    );
    print("Sauvegarde du score dans le fichier JSON");
}

  void onWordTap(String word) {
    if (matched.contains(word)) return;

    if (selectedWord == null) {
      selectedWord = word;
      selectingFrench = frenchWords.contains(word);
      setState(() {});
    } else {
      final first = selectedWord!;
      final second = word;

      bool correct = false;

      if (selectingFrench && correctMap[first] == second) {
        correct = true;
      } else if (!selectingFrench && correctMap[second] == first) {
        correct = true;
      }

      if (correct) {
        matched.add(first);
        matched.add(second);
        score++;
        setState(() {});
        Timer(const Duration(seconds: 1), () {
          if (matched.length == 8) {
            generatePairs(); // relancer si tout trouvé
          } else {
            setState(() {});
          }
        });
      } else {
        wrong.add(first);
        wrong.add(second);
        setState(() {});
        Timer(const Duration(seconds: 1), () {
          wrong.remove(first);
          wrong.remove(second);
          selectedWord = null;
          setState(() {});
        });
        return;
      }

      selectedWord = null;
    }
  }

  Widget buildWordBox(String word) {
    final isMatched = matched.contains(word);
    final isWrong = wrong.contains(word);
    final isSelected = word == selectedWord;

    if (isMatched) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => onWordTap(word),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isWrong
              ? Colors.red[300]
              : isSelected
                  ? Colors.blue[100]
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            word,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fast Pair Quiz'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
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
                  const Text(
                      'Trouver le plus de paires possible.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    LinearProgressIndicator(
              value: (gameDuration - timeLeft) / gameDuration,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(theme.primaryColor),
            ),
             Text(
              '$timeLeft s',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
             ),
                  ],
                ),
              ),
            ),         
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: frenchWords.map(buildWordBox).toList(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: englishWords.map(buildWordBox).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
