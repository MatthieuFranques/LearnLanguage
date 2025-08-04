import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_language/models/sentence.dart';

class SentenceRestructureQuiz extends StatefulWidget {
  const SentenceRestructureQuiz({super.key});

  @override
  State<SentenceRestructureQuiz> createState() => _SentenceRestructureQuizState();
}

class _SentenceRestructureQuizState extends State<SentenceRestructureQuiz> {
  final List<String> sentences = [
    'I am going to the market',
    'She reads a book every evening',
    'We are learning Flutter today',
  ];

  late String correctSentence;
  late List<String> shuffledWords;
  List<String> selectedWords = [];
  List<Sentence> selectedSentences = [];


  @override
  void initState() {
    super.initState();
    loadNewSentence();
  }

   Future<void> loadSentences() async {
    final String response = await rootBundle.loadString('assets/sentences.json');
    final List data = json.decode(response);

    // Charge un grand nombre de mots (par exemple 50 ou 100)
    List<Sentence> loadedSentences = data.map((e) => Sentence(e['english'], e['french'])).toList();

    setState(() {
      selectedSentences = loadedSentences;
      // isLoading = false;
      // isEnglishToFrench = Random().nextBool();
    });
  }

  void loadNewSentence() {
    final random = Random();
    correctSentence = sentences[random.nextInt(sentences.length)];
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

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? '✅ Bonne réponse !' : '❌ Incorrect'),
        content: Text('Phrase attendue :\n"$correctSentence"'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restructure la phrase'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: 
         Column(
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
                    'Phrase  / 10',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 16),
                   const Text(
                      'Remets la phrase dans le bon ordre :',
                      style:  TextStyle(fontSize: 18),
                    ),
                     const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: shuffledWords.map((word) {
                        final alreadyUsed = selectedWords.contains(word);
                        return ElevatedButton(
                          onPressed: alreadyUsed ? null : () => onWordSelected(word),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: alreadyUsed ? Colors.grey[300] : null,
                          ),
                          child: Text(word),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
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
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: selectedWords.isNotEmpty ? onValidate : null,
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
    );
  }
}
