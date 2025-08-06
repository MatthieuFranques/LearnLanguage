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
      'color': AppColors.primaryLight,
      'icon': Icons.quiz,
      'page': const VocabularyQuiz(),
    },
    {
      'title': 'Quiz Multiple',
      'color': AppColors.textTertiary,
      'icon': Icons.radio_button_checked,
      'page': const VocabularyChoiceQuiz(),
    },
    {
      'title': 'Quiz de rapidité',
      'color': AppColors.highlight,
      'icon': Icons.timer,
      'page': const FastPairQuiz(),
    },
    {
      'title': 'Trouver le bon ordre',
      'color': AppColors.textSecondary,
      'icon': Icons.format_list_numbered,
      'page': const SentenceRestructureQuiz(),
    },
    {
      'title': 'Compréhension',
      'color': AppColors.error,
      'icon': Icons.headphones,
      'page': const VocabularyListeningQuiz(),
    },
    {
      'title': 'Prononciation',
      'color': AppColors.primaryDark,
      'icon': Icons.campaign,
      'page': const VocabularyListeningQuiz(), // À remplacer plus tard
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Accueil', showBackButton: false),
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.15),
                      color.withOpacity(0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: Offset(0, 6),
                    ),
                  ],
                  border: Border.all(
                    color: color.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: color.withOpacity(0.2),
                  highlightColor: Colors.transparent,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => page),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 40, color: color),
                        const SizedBox(height: 12),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
