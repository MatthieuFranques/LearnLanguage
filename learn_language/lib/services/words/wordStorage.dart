import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/word.dart';

class WordStorage {
  static Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/words.json');
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
      await file.writeAsString(data);
      final decoded = jsonDecode(data) as List;
      return decoded.map((e) => Word(e['english'], e['french'])).toList();
    }
  }

  static Future<void> addWord(Word word) async {
    if (word.english.isEmpty || word.french.isEmpty) {
      throw Exception('Les mots ne peuvent pas être vides');
    }
    print('Before adding word');
    final words = await readWords();
    print('Ajout du mot : ${word.english} - ${word.french}');
    if (words.any((w) => w.english == word.english)) {
      throw Exception('Le mot existe déjà');
    }
    words.add(word);
    final file = await _getLocalFile();
    final encoded = jsonEncode(
        words.map((w) => {'english': w.english, 'french': w.french}).toList());
    print('Enregistrement des mots mis à jour');
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    print('Écriture dans le fichier : ${file.path}');
    print('Contenu du fichier : $encoded');
    await file.writeAsString(encoded);
  }
}
