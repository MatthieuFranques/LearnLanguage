import 'dart:convert';
import 'dart:io';
import 'package:learn_language/models/ranking.dart';
import 'package:path_provider/path_provider.dart';

class RankingStorage {
  // Obtient le chemin du fichier local
  static Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/ranking.json');
  }

  // Lit les données du fichier local ou initialise si vide
  static Future<List<Ranking>> readWords() async {
    final file = await _getLocalFile();

    if (!await file.exists() || (await file.readAsString()).trim().isEmpty) {
      // Initialise un fichier vide avec []
      await file.writeAsString('[]');
    }

    final data = await file.readAsString();
    final decoded = jsonDecode(data) as List;
    return decoded.map((e) => Ranking(e['quizName'], e['score'])).toList();
  }

  // Ajoute une nouvelle entrée dans le fichier
  static Future<void> addWord(Ranking ranking) async {
    if (ranking.quizName.isEmpty || ranking.score.isEmpty) {
      throw Exception('Les champs ne peuvent pas être vides');
    }

    final existingData = await readWords();
    existingData.add(ranking);

    final file = await _getLocalFile();
    final encoded = jsonEncode(
      existingData.map((r) => {'quizName': r.quizName, 'score': r.score}).toList(),
    );

    await file.writeAsString(encoded);
    print('✅ Score enregistré : ${ranking.quizName} - ${ranking.score}');
  }
}
