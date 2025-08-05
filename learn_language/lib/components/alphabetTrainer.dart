import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AlphabetTrainer extends StatefulWidget {
  const AlphabetTrainer({super.key});

  @override
  State<AlphabetTrainer> createState() => _AlphabetTrainerState();
}

class _AlphabetTrainerState extends State<AlphabetTrainer> {
  final FlutterTts _tts = FlutterTts();
  String? _selectedLetter;
  String? _selectedPhonetic;
  bool _isSpeaking = false;

  final Map<String, String> phoneticMap = {
    'A': '[ei]', 'E': '[i:]', 'I': '[ai]', 'O': '[əʊ]', 'U': '[ju:]',
    'B': '[bi:]', 'C': '[si:]', 'D': '[di:]', 'F': '[ef]', 'G': '[dʒi:]',
    'H': '[eitʃ]', 'J': '[dʒei]', 'K': '[kei]', 'L': '[el]', 'M': '[em]',
    'N': '[en]', 'P': '[pi:]', 'Q': '[kju:]', 'R': '[ɑ:]', 'S': '[es]',
    'T': '[ti:]', 'V': '[vi:]', 'W': '[ˈdʌblju:]', 'X': '[eks]', 'Y': '[wai]', 'Z': '[zed]',
  };

  final List<String> vowels = ['A', 'E', 'I', 'O', 'U'];
  final List<String> consonants = [
    'B', 'C', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'M',
    'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y', 'Z'
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
      _selectedPhonetic = phoneticMap[letter];
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Widget _buildLetterGrid(List<String> letters, ThemeData theme) {
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
                letter,
                style: TextStyle(
                  fontSize: 18,
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Clique sur une lettre pour l’entendre et voir sa prononciation.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Voyelles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: theme.primaryColor)),
            ),
            const SizedBox(height: 8),
            _buildLetterGrid(vowels, theme),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Consonnes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: theme.primaryColor)),
            ),
            const SizedBox(height: 8),
            _buildLetterGrid(consonants, theme),

            const SizedBox(height: 24),
            if (_selectedLetter != null && _selectedPhonetic != null)
              Column(
                children: [
                  Text(
                    'Lettre : $_selectedLetter',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Prononciation : $_selectedPhonetic',
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
          ],
        ),
      );
  }
}
