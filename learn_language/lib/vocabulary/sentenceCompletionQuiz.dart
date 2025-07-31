import 'package:flutter/material.dart';

class SentenceCompletionQuiz extends StatelessWidget {
  const SentenceCompletionQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complétion de phrase'),
      ),
      body: const Center(
        child: Text(
          'En cours de construction... 🛠️',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}