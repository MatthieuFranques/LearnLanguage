import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_language/components/customAppBar.dart';
import 'package:learn_language/components/customEndDialog.dart';
import 'package:learn_language/components/footerWave.dart';
import 'package:learn_language/components/primaryButton.dart';
import 'package:learn_language/models/ranking.dart';
import 'package:learn_language/models/sentence.dart';
import 'package:learn_language/services/words/rankingStorage.dart';
import 'package:learn_language/theme/appColor.dart';

class SentenceRestructureQuiz extends StatefulWidget {
  const SentenceRestructureQuiz({super.key});

  @override
  State<SentenceRestructureQuiz> createState() =>
      _SentenceRestructureQuizState();
}

class _SentenceRestructureQuizState extends State<SentenceRestructureQuiz> {
  late String correctSentence;
  late List<String> shuffledWords;
  List<String> selectedWords = [];
  List<Sentence> selectedSentences = [];
  int currentSentenceIndex = 0;
  final int totalSentences = 8;
  int correctAnswers = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSentences();
  }

  Future<void> loadSentences() async {
    final String response =
        await rootBundle.loadString('assets/sentences.json');
    final List data = json.decode(response);

    List<Sentence> loadedSentences =
        data.map((e) => Sentence(e['english'], e['french'])).toList();
    loadedSentences.shuffle();

    setState(() {
      selectedSentences = loadedSentences.take(totalSentences).toList();
      isLoading = false;
    });

    loadNewSentence();
  }

  Future<void> saveScoreOnce() async {
    await RankingStorage.addWord(
        Ranking('Réorganisation de phrases', correctAnswers.toString()));
    print("Sauvegarde du score dans le fichier JSON");
  }

  void loadNewSentence() {
    if (currentSentenceIndex >= totalSentences) {
      saveScoreOnce();
      showDialog(
        context: context,
        builder: (_) => CustomEndDialog(
          title: '🎉 Quiz terminé !',
          message:
              'Tu as terminé toutes les phrases ! Phrases trouvées : $correctAnswers / $totalSentences.',
          score: correctAnswers,
          onReplay: () {
            currentSentenceIndex = 0;
            correctAnswers = 0;
            loadNewSentence();
          },
          onQuit: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      );
      return;
    }

    final sentence = selectedSentences[currentSentenceIndex];
    correctSentence = sentence.english;
    shuffledWords = correctSentence.split(' ')..shuffle();
    selectedWords.clear();
    setState(() {});
  }

  void onWordSelected(String word) {
    if (selectedWords.contains(word)) return;
    selectedWords.add(word);
    setState(() {});
  }

  void onValidate() {
    final result = selectedWords.join(' ');
    final isCorrect = result == correctSentence;

    if (isCorrect) {
      correctAnswers++;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? '✅ Bonne réponse !' : '❌ Incorrect'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phrase attendue :\n"$correctSentence"'),
            const SizedBox(height: 12),
            Text('Phrases trouvées : $correctAnswers'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              currentSentenceIndex++; // ✅ Avance après validation
              loadNewSentence();
            },
            child: const Text('Suivant'),
          )
        ],
      ),
    );
  }

  void onClear() {
    selectedWords.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Restructurer la phrase'),
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0,
                -0.5), // centré horizontalement, un peu plus haut verticalement
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                              'Phrase ${currentSentenceIndex + 1} / $totalSentences',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Remets la phrase dans le bon ordre :',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: shuffledWords.map((word) {
                                final alreadyUsed =
                                    selectedWords.contains(word);
                                return ElevatedButton(
                                  onPressed: alreadyUsed
                                      ? null
                                      : () => onWordSelected(word),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: alreadyUsed
                                        ? Colors.grey[300]
                                        : AppColors.buttonHover,
                                  ),
                                  child: Text(word),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 68),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        selectedWords.join(' '),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 42),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed:
                              selectedWords.isNotEmpty ? onValidate : null,
                          icon: const Icon(Icons.check),
                          label: const Text('Valider'),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: onClear,
                          child: const Text('Réinitialiser'),
                        ),
                      ],
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
