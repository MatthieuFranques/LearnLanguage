import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ConjugationTrainer extends StatefulWidget {
  const ConjugationTrainer({super.key});

  @override
  State<ConjugationTrainer> createState() => _ConjugationTrainerState();
}

class _ConjugationTrainerState extends State<ConjugationTrainer> {
  final FlutterTts _tts = FlutterTts();
  String? _selectedForm;
  bool _isSpeaking = false;

  final Map<String, String> conjugationMap = {
  // 🔵 Present Simple
  'I am': 'Present',
  'You are': 'Present',
  'He is': 'Present',
  'She is': 'Present',
  'We are': 'Present',
  'They are': 'Present',

  // 🔴 Past Simple
  'I was': 'Past',
  'You were': 'Past',
  'He was': 'Past',
  'She was': 'Past',
  'We were': 'Past',
  'They were': 'Past',

  // 🟢 Future Simple
  'I will be': 'Future',
  'You will be': 'Future',
  'He will be': 'Future',
  'She will be': 'Future',
  'We will be': 'Future',
  'They will be': 'Future',

  // 🔵 Present Continuous (be + being)
  'I am being': 'Present Continuous',
  'You are being': 'Present Continuous',
  'He is being': 'Present Continuous',
  'She is being': 'Present Continuous',
  'We are being': 'Present Continuous',
  'They are being': 'Present Continuous',

  // 🔴 Past Continuous (was/were + being)
  'I was being': 'Past Continuous',
  'You were being': 'Past Continuous',
  'He was being': 'Past Continuous',
  'She was being': 'Past Continuous',
  'We were being': 'Past Continuous',
  'They were being': 'Past Continuous',

  // 📣 Imperative (no subject)
  'Be': 'Imperative',
  'Be careful': 'Imperative',
  'Be quiet': 'Imperative',
  'Be nice': 'Imperative',
};


  Future<void> _speak(String phrase) async {
    if (_isSpeaking) return;
    _isSpeaking = true;
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.4);
    await _tts.setPitch(1.0);
    await _tts.speak(phrase);
    await Future.delayed(const Duration(milliseconds: 600));
    _isSpeaking = false;

    setState(() {
      _selectedForm = phrase;
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Widget _buildConjugationGrid(String tense, ThemeData theme) {
    final items = conjugationMap.entries
        .where((entry) => entry.value == tense)
        .map((e) => e.key)
        .toList();

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: items.map((form) {
        final isSelected = _selectedForm == form;
        return GestureDetector(
          onTap: () => _speak(form),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary.withOpacity(0.85) : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                form,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  @override
Widget build(BuildContext context) {
  final theme = Theme.of(context);

 final Map<String, String> explanations = {
  'Present': 'Le présent simple est utilisé pour exprimer des vérités générales, des habitudes ou des états permanents.\nExemple : I am happy.',
  'Present Continuous': 'Le présent continu (be + verbe en -ing) exprime une action en cours au moment présent. Il n’existe pas en français, mais il est indispensable en anglais.\nExemple : I am working.',
  'Past': 'Le passé simple (past simple) est utilisé pour décrire des actions terminées dans le passé. Il correspond souvent au passé composé, à l’imparfait ou au passé simple en français.\nExemple : She walked to school.',
  'Past Continuous': 'Le past continuous (was/were + -ing) sert à décrire une action en cours dans le passé. Il permet de créer des nuances que le français exprime autrement.\nExemple : I was reading when he called.',
  'Future': 'Le futur avec "will" exprime des décisions, des promesses ou des événements futurs.\nExemple : They will be ready.',
};


final List<String> tenses = [
  'Present',
  'Present Continuous',
  'Past',
  'Past Continuous',
  'Future',
];

  return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          children: [
          const SizedBox(height: 12),
          const Text(
            'Clique sur une forme pour l’entendre.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          ...tenses.map((tense) {
            final icon = {
                'Present': '📘',
                'Present Continuous': '🔵',
                'Past': '📕',
                'Past Continuous': '🔴',
                'Future': '📗',
              }[tense];

            return ExpansionTile(
              title: Text(
                '$icon $tense',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: theme.primaryColor),
              ),
              children: [
                const SizedBox(height: 4),
                Text(explanations[tense]!, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 12),
                _buildConjugationGrid(tense, theme),
                const SizedBox(height: 16),
              ],
            );
          }),

          const SizedBox(height: 24),
          if (_selectedForm != null)
            Center(
              child: Text(
                '🗣️ $_selectedForm',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
  );
}
}