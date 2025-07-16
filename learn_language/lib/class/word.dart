class Word {
  final String english;
  final String french;

  Word(this.english, this.french);
}

class WordList {
  final List<Word> words = [];

  void addWord(String english, String french) {
    words.add(Word(english, french));
  }
}
