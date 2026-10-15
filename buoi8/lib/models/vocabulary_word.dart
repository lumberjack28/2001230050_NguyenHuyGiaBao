class VocabularyWord {
  final int id;
  final String word;
  final String meaning;
  final DateTime due;

  VocabularyWord({
    required this.id,
    required this.word,
    required this.meaning,
    required this.due,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'meaning': meaning,
        'due': due.toIso8601String(),
      };

  factory VocabularyWord.fromJson(Map<String, dynamic> json) => VocabularyWord(
        id: json['id'] as int,
        word: json['word'] as String,
        meaning: json['meaning'] as String,
        due: DateTime.parse(json['due'] as String),
      );
}
