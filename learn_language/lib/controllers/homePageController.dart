import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learn_language/models/word.dart';
import 'package:learn_language/services/api/apiTranslate.dart';
import 'package:learn_language/services/words/wordStorage.dart';

class HomePageController {
  bool isEnglishToFrench = true;

  final TextEditingController englishController = TextEditingController();
  final TextEditingController frenchController = TextEditingController();

  Timer? _debounce;

  void dispose() {
    englishController.dispose();
    frenchController.dispose();
    _debounce?.cancel();
  }

  void toggleDirection() {
    final temp = englishController.text;
    englishController.text = frenchController.text;
    frenchController.text = temp;

    isEnglishToFrench = !isEnglishToFrench;
  }

  void onEnglishChanged(VoidCallback onTranslate, VoidCallback onClearFrench) {
    if (!isEnglishToFrench) return;
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final english = englishController.text.trim();
      if (english.isNotEmpty) {
        onTranslate();
      } else {
        onClearFrench();
      }
    });
  }

  void onFrenchChanged(VoidCallback onTranslate, VoidCallback onClearEnglish) {
    if (isEnglishToFrench) return;
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final french = frenchController.text.trim();
      if (french.isNotEmpty) {
        onTranslate();
      } else {
        onClearEnglish();
      }
    });
  }

  Future<String?> translateWord() async {
    try {
      if (isEnglishToFrench) {
        return await translateToFrench(englishController.text.trim());
      } else {
        return await translateToEnglish(frenchController.text.trim());
      }
    } catch (e) {
      return null; // erreur
    }
  }

  Future<bool> addWord() async {
    final english = englishController.text.trim();
    final french = frenchController.text.trim();

    if (english.isNotEmpty && french.isNotEmpty) {
      final word = Word(english, french);
      await WordStorage.addWord(word);
      englishController.clear();
      frenchController.clear();
      return true;
    }
    return false;
  }
}
