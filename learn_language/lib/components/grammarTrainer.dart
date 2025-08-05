import 'package:flutter/material.dart';

class GrammarTrainer extends StatelessWidget {
  const GrammarTrainer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Map<String, String> grammarLessons = {
      '🧠 Les modaux (can, must, should...)': '''
Les verbes modaux expriment :
- La capacité, l’obligation, le conseil, la permission...

🔹 Exemples :
- Can : I can swim.
- Must : You must stop.
- Should : You should eat better.''',

      '📰 Les articles (a, an, the)': '''
- "a" : devant un mot qui commence par un son consonantique
- "an" : devant un mot qui commence par un son vocalique
- "the" : article défini

🔹 Exemples :
- A cat, an apple, the sun''',

      '👥 Les adjectifs possessifs': '''
Ils indiquent à qui appartient quelque chose.

🔹 Exemples :
- my, your, his, her, its, our, their

🔹 Phrase :
- This is my phone.''',

      '📣 L’impératif': '''
Utilisé pour donner un ordre ou un conseil.

🔹 Structure :
Base verbale (sans sujet)

🔹 Exemple :
- Sit down!
- Be careful!''',

      '🙋‍♂️ Les pronoms personnels': '''
Utilisés pour remplacer les noms dans une phrase.

🔹 Exemples :
- I, you, he, she, it, we, they

🔹 Phrase :
- He is happy.''',
    };

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: grammarLessons.entries.map((entry) {
            return ExpansionTile(
              title: Text(
                entry.key,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
    );
  }
}
