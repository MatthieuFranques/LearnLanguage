import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_language/models/ranking.dart';
import 'package:learn_language/services/words/rankingStorage.dart'; // Adapte le chemin
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// 1. On crée un faux fournisseur de chemin pour éviter l'erreur path_provider
class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '.'; // Utilise le répertoire courant pour le test
  }
}

void main() {
  const String fileName = 'ranking.json';
  late File testFile;

  setUp(() async {
    // Initialise le mock de path_provider
    PathProviderPlatform.instance = MockPathProviderPlatform();
    testFile = File('./$fileName');
    
    // On s'assure que le fichier est propre avant chaque test
    if (await testFile.exists()) {
      await testFile.delete();
    }
  });

  tearDown(() async {
    // Nettoyage après les tests
    if (await testFile.exists()) {
      await testFile.delete();
    }
  });

  group('RankingStorage Tests', () {
    
    test('readWords devrait initialiser un fichier vide [] s\'il n\'existe pas', () async {
      final rankings = await RankingStorage.readWords();
      
      expect(rankings, isEmpty);
      expect(await testFile.exists(), true);
      expect(await testFile.readAsString(), '[]');
    });

    test('addWord devrait ajouter un score et le sauvegarder correctement', () async {
      final newRanking = Ranking('Quiz Flutter', '10/10');

      await RankingStorage.addWord(newRanking);

      final rankings = await RankingStorage.readWords();
      
      expect(rankings.length, 1);
      expect(rankings[0].quizName, 'Quiz Flutter');
      expect(rankings[0].score, '10/10');
    });

    test('addWord devrait lever une exception si les champs sont vides', () async {
      final invalidRanking = Ranking('', '');

      expect(
        () => RankingStorage.addWord(invalidRanking),
        throwsA(isA<Exception>()),
      );
    });

    test('readWords devrait parser correctement plusieurs entrées', () async {
      // Pré-remplissage manuel du fichier
      final initialData = [
        {'quizName': 'Maths', 'score': '5/5'},
        {'quizName': 'Anglais', 'score': '3/5'}
      ];
      await testFile.writeAsString(jsonEncode(initialData));

      final rankings = await RankingStorage.readWords();

      expect(rankings.length, 2);
      expect(rankings[0].quizName, 'Maths');
      expect(rankings[1].quizName, 'Anglais');
    });
  });
}