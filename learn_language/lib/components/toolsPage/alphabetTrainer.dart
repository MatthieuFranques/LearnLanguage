import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learn_language/theme/appColor.dart';

class AlphabetTrainer extends StatefulWidget {
  const AlphabetTrainer({super.key});

  @override
  State<AlphabetTrainer> createState() => _AlphabetTrainerState();
}

class _AlphabetTrainerState extends State<AlphabetTrainer> {
  final FlutterTts _tts = FlutterTts();
  String? _selectedLetter;
  bool _isSpeaking = false;

  final Map<String, String> phoneticMap = {
    'A': '[ei]',
    'E': '[i:]',
    'I': '[ai]',
    'O': '[əʊ]',
    'U': '[ju:]',
    'B': '[bi:]',
    'C': '[si:]',
    'D': '[di:]',
    'F': '[ef]',
    'G': '[dʒi:]',
    'H': '[eitʃ]',
    'J': '[dʒei]',
    'K': '[kei]',
    'L': '[el]',
    'M': '[em]',
    'N': '[en]',
    'P': '[pi:]',
    'Q': '[kju:]',
    'R': '[ɑ:]',
    'S': '[es]',
    'T': '[ti:]',
    'V': '[vi:]',
    'W': '[ˈdʌblju:]',
    'X': '[eks]',
    'Y': '[wai]',
    'Z': '[zed]',
  };

  final List<String> vowels = ['A', 'E', 'I', 'O', 'U'];
  final List<String> consonants = [
    'B',
    'C',
    'D',
    'F',
    'G',
    'H',
    'J',
    'K',
    'L',
    'M',
    'N',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  Future<void> _speakLetter(String letter) async {
    if (_isSpeaking) return; // bloque si déjà en train de parler
    _isSpeaking = true;
    await _tts.setLanguage('en-US');
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.4);
    await _tts.speak(letter);
    // Petite pause (optionnelle) pour laisser le temps à la synthèse
    await Future.delayed(const Duration(milliseconds: 600));
    _isSpeaking = false;

    setState(() {
      _selectedLetter = letter;
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Widget _buildLetterGrid(List<String> letters) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 6,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: letters.map((letter) {
        final isSelected = _selectedLetter == letter;
        return GestureDetector(
          onTap: () => _speakLetter(letter),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.85)
                  : AppColors.border,
              borderRadius: BorderRadius.circular(10),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      isSelected ? AppColors.textHint : AppColors.textcolorBg,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Clique sur une lettre pour l’entendre et voir sa prononciation.',
            style: TextStyle(fontSize: 16, color : AppColors.textDisabled),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Voyelles',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ),
          const SizedBox(height: 8),
          _buildLetterGrid(vowels),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Consonnes',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ),
          const SizedBox(height: 8),
          _buildLetterGrid(consonants),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
