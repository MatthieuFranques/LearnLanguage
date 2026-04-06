import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_language/models/word.dart';
import 'package:learn_language/services/words/wordStorage.dart'; // Adapte le chemin
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// 1. Mock pour path_provider
class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '.'; // Répertoire local du projet pour le test
  }
}

void main() {
  // Nécessaire pour interagir avec les services Flutter comme rootBundle
  TestWidgetsFlutterBinding.ensureInitialized();

  const String fileName = 'words.json';
  late File testFile;

  setUp(() async {
    PathProviderPlatform.instance = MockPathProviderPlatform();
    testFile = File('./$fileName');

    if (await testFile.exists()) {
      await testFile.delete();
    }

    // 2. Mock pour rootBundle (simule le fichier assets/words.json)
    // On définit ce que rootBundle doit renvoyer quand on appelle loadString
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
      final Uint8List encoded = utf8.encoder.convert(jsonEncode([
        {'english': 'Hello', 'french': 'Bonjour'}
      ]));
      return encoded.buffer.asByteData();
    });
  });

  tearDown(() async {
    if (await testFile.exists()) {
      await testFile.delete();
    }
  });

  group('WordStorage Tests', () {
    
    test('readWords charge les assets si le fichier local n\'existe pas', () async {
      final words = await WordStorage.readWords();

      expect(words.length, 1);
      expect(words[0].english, 'Hello');
      expect(await testFile.exists(), true);
    });

    test('addWord ajoute un nouveau mot avec succès', () async {
      // On s'assure d'abord qu'on a le mot de base
      final newWord = Word('Apple', 'Pomme');
      
      await WordStorage.addWord(newWord);

      final words = await WordStorage.readWords();
      expect(words.any((w) => w.english == 'Apple'), true);
      expect(words.length, 2); // Hello (asset) + Apple
    });

    test('addWord lève une exception si le mot est vide', () async {
      final invalidWord = Word('', 'Test');

      expect(
        () => WordStorage.addWord(invalidWord),
        throwsA(predicate((e) => e is Exception && e.toString().contains('vides'))),
      );
    });

    test('addWord lève une exception si le mot existe déjà', () async {
      // "Hello" est déjà chargé via le mock de l'asset au début
      final duplicateWord = Word('Hello', 'Bonjour');

      expect(
        () => WordStorage.addWord(duplicateWord),
        throwsA(predicate((e) => e is Exception && e.toString().contains('existe déjà'))),
      );
    });
  });
}