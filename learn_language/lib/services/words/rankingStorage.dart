import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:learn_language/models/ranking.dart';
import 'package:path_provider/path_provider.dart';

class RankingStorage {
  static Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/ranking.json');
  }
 
  static Future<List<Ranking>> readWords() async {
    final file = await _getLocalFile();
  final data = await rootBundle.loadString('assets/ranking.json');
  await file.writeAsString(data);
  final decoded = jsonDecode(data) as List;
  return decoded.map((e) => Ranking(e['quizName'], e['score'])).toList();
    
  }

   static Future<void> addWord(Ranking ranking) async {
    if (ranking.quizName.isEmpty || ranking.score.isEmpty) {
      throw Exception('Les mots ne peuvent pas être vides');
    }
    print('Before adding word');
    final jsonContent = await readWords();
    print('Ajout du mot : ${ranking.quizName} - ${ranking.score}');
    jsonContent.add(ranking);
    final file = await _getLocalFile();
    final encoded = jsonEncode(
        jsonContent.map((r) => {'quizName': r.quizName, 'score': r.score}).toList());
    print('Enregistrement des mots mis à jour');
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    print('Écriture dans le fichier : ${file.path}');
    print('Contenu du fichier : $encoded');
    await file.writeAsString(encoded);
  }
 }