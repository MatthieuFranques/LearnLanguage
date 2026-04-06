import 'package:flutter_test/flutter_test.dart';
import 'package:learn_language/controllers/homePageController.dart'; // Adapte le chemin


void main() {
  late HomePageController controller;

  setUp(() {
    controller = HomePageController();
  });

  tearDown(() {
    controller.dispose();
  });

  group('HomePageController Logic Tests', () {
    test('Initial state should be English to French', () {
      expect(controller.isEnglishToFrench, true);
    });

    test('toggleDirection should swap text and boolean state', () {
      controller.englishController.text = 'Hello';
      controller.frenchController.text = 'Bonjour';

      controller.toggleDirection();

      expect(controller.isEnglishToFrench, false);
      expect(controller.englishController.text, 'Bonjour');
      expect(controller.frenchController.text, 'Hello');
    });
  });

  group('Debounce Logic', () {
    test('onEnglishChanged triggers onTranslate after 500ms', () async {
      bool translateCalled = false;
      controller.isEnglishToFrench = true;
      controller.englishController.text = 'Dog';

      controller.onEnglishChanged(
        () => translateCalled = true,
        () {},
      );

      // Avant 500ms, ne doit pas être appelé
      expect(translateCalled, false);

      // Attendre la fin du debounce
      await Future.delayed(const Duration(milliseconds: 600));

      expect(translateCalled, true);
    });

    test('onEnglishChanged calls onClearFrench if text is empty', () async {
      bool clearCalled = false;
      controller.isEnglishToFrench = true;
      controller.englishController.text = '';

      controller.onEnglishChanged(
        () {},
        () => clearCalled = true,
      );

      await Future.delayed(const Duration(milliseconds: 600));

      expect(clearCalled, true);
    });
  });
}