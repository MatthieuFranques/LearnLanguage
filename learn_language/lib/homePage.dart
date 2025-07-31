import 'package:flutter/material.dart';
import 'package:learn_language/vocabulary/SentenceCompletionQuiz.dart';
import 'package:learn_language/vocabulary/fastPairQuiz.dart';
import 'package:learn_language/vocabulary/sentenceRestructureQuiz.dart';
import 'package:learn_language/vocabulary/trueFalseQuiz.dart';
import 'package:learn_language/vocabulary/vocabularyChoiceQuiz.dart';
import 'package:learn_language/vocabulary/vocabularyQuiz.dart';

class HomePage extends StatelessWidget  {
   HomePage({super.key});
 final List<Map<String, dynamic>> quizzes = [
    {
      'title': 'Quiz',
      'color': Colors.blue,
      'icon': Icons.quiz,
      'page': const VocabularyQuiz(),
    },
    {
      'title': 'Quiz Multiple',
      'color': Colors.green,
      'icon': Icons.list,
      'page': const VocabularyChoiceQuiz(),
    },
    {
      'title': 'Quiz de rapidité',
      'color': Colors.orange,
      'icon': Icons.timer,
      'page': const FastPairQuiz(),
    },
    {
      'title': 'Trouver le bon ordre',
      'color': Colors.purple,
      'icon': Icons.sort,
      'page': const SentenceRestructureQuiz(),
    },
    {
  'title': 'Complétion de phrase',
  'color': Colors.teal,
  'icon': Icons.edit_note,
  'page': const SentenceCompletionQuiz(), // À créer
},
{
  'title': 'Vrai ou Faux',
  'color': Colors.redAccent,
  'icon': Icons.check_circle,
  'page': const TrueFalseQuiz(), // À créer
},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélection du Quiz'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.builder(
          itemCount: quizzes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final quiz = quizzes[index];
            final Color color = quiz['color'] as Color;
            final IconData icon = quiz['icon'] as IconData;
            final String title = quiz['title'] as String;
            final Widget page = quiz['page'] as Widget;

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => page),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 40, color: color),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}