class WordModel {
  final String word;
  final String definition;

  WordModel({required this.word, required this.definition});

  factory WordModel.fromJson(Map<String, dynamic> json) {
    // Assuming the first meaning is the one we want
    String meaning = json['meanings'][0]['definitions'][0]['definition'];
    return WordModel(
      word: json['word'],
      definition: meaning,
    );
  }
}
