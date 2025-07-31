import 'package:flutter/material.dart';

class CustomEndDialog extends StatelessWidget {
  final String title;
  final String message;
  final int? score; // Optionnel
  final String? replayText;
  final String? quitText;
  final VoidCallback onReplay;
  final VoidCallback onQuit;

  const CustomEndDialog({
    Key? key,
    required this.title,
    required this.message,
    this.score,
    this.replayText = 'Rejouer',
    this.quitText = 'Quitter',
    required this.onReplay,
    required this.onQuit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          if (score != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                'Tu as obtenu $score point(s).',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onQuit,
          child: Text(quitText ?? 'Quitter'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); 
            onReplay();
          },
          child: Text(replayText ?? 'Rejouer'),
        ),
      ],
    );
  }
}
