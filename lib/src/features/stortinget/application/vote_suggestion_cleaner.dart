class VoteSuggestionCleaner {
  static String clean(String text) {
    return text
        .replaceAll(RegExp(r'\n'), ' ')
        .replaceAll(RegExp(r'<\/?\w+(?: [^>]+)?>'), '')
        .trim();
  }
}
