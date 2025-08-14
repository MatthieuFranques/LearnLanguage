import 'package:flutter/material.dart';
import 'package:learn_language/components/customAppBar.dart';
import 'package:learn_language/theme/appColor.dart';
import 'package:learn_language/vocabulary/fastPairQuiz.dart';
import 'package:learn_language/vocabulary/sentenceRestructureQuiz.dart';
import 'package:learn_language/vocabulary/vocabularyListeningQuiz.dart';
import 'package:learn_language/vocabulary/vocabularyChoiceQuiz.dart';
import 'package:learn_language/vocabulary/vocabularyQuiz.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
final List<Map<String, dynamic>> quizzes = [
  {
    'title': 'Quiz',
    'color': AppColors.quizBlue,
    'icon': Icons.quiz,
    'page': const VocabularyQuiz(),
  },
  {
    'title': 'Quiz Multiple',
    'color': AppColors.quizBlueDeep,
    'icon': Icons.radio_button_checked,
    'page': const VocabularyChoiceQuiz(),
  },
  {
    'title': 'Quiz de rapidité',
    'color': AppColors.quizOrange,
    'icon': Icons.timer,
    'page': const FastPairQuiz(),
  },
  {
    'title': 'Trouver le bon ordre',
    'color': AppColors.quizGreen,
    'icon': Icons.format_list_numbered,
    'page': const SentenceRestructureQuiz(),
  },
  {
    'title': 'Compréhension',
    'color': AppColors.quizPink,
    'icon': Icons.headphones,
    'page': const VocabularyListeningQuiz(),
  },
  {
    'title': 'Prononciation',
    'color': AppColors.quizPurple,
    'icon': Icons.campaign,
    'page': const VocabularyListeningQuiz(),
  },
];

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Accueil',
        showBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          itemCount: quizzes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.1,
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
color: color.withOpacity(1.0).withRed((color.red * 0.99).toInt()),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withOpacity(0.05),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: color.withOpacity(0.4),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                 Icon(
                        icon,
                        size: 42,
                        color: AppColors.textPrimary,
                      ),

                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
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