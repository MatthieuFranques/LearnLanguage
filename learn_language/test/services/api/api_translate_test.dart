import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:learn_language/services/api/apiTranslate.dart';

void main() {
  group('Tests de Traduction', () {
    
    test('translateToFrench doit retourner le texte traduit', () async {
      // On crée un client qui simule la réponse de l'API
      final mockClient = MockClient((request) async {
        final mapJson = {
          'responseData': {'translatedText': 'Bonjour'}
        };
        return http.Response(json.encode(mapJson), 200);
      });

      // On utilise runWithClient pour forcer ton code à utiliser ce client mocké
      final result = await http.runWithClient(() => translateToFrench('Hello'), () => mockClient);

      expect(result, equals('Bonjour'));
    });

    test('translateToEnglish doit retourner le texte anglais', () async {
      final mockClient = MockClient((request) async {
        final mapJson = {
          'responseData': {'translatedText': 'Apple'}
        };
        return http.Response(json.encode(mapJson), 200);
      });

      final result = await http.runWithClient(() => translateToEnglish('Pomme'), () => mockClient);

      expect(result, equals('Apple'));
    });

    test('doit lever une Exception si le serveur répond 500', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      expect(
        () => http.runWithClient(() => translateToFrench('Error'), () => mockClient),
        throwsException,
      );
    });
  });
}