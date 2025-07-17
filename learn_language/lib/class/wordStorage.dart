import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import '../class/word.dart';

class WordStorage {
  static Future<File> _getLocalFile() async {
    return File('assets/words.json');
  }

  static Future<List<Word>> readWords() async {
    final file = await _getLocalFile();

    if (await file.exists()) {
      final contents = await file.readAsString();
      final data = jsonDecode(contents) as List;
      return data.map((e) => Word(e['english'], e['french'])).toList();
    } else {
      // Première fois : copie depuis assets
      final data = await rootBundle.loadString('assets/words.json');
      final file = await _getLocalFile();
      await file.writeAsString(data);
      final decoded = jsonDecode(data) as List;
      return decoded.map((e) => Word(e['english'], e['french'])).toList();
    }
  }

  static Future<void> addWord(Word word) async {
    final words = await readWords();
    words.add(word);

    final file = await _getLocalFile();
    final encoded = jsonEncode(
        words.map((w) => {'english': w.english, 'french': w.french}).toList());
    await file.writeAsString(encoded);
  }
}
