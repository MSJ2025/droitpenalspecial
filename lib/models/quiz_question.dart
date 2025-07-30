class QuizOption {
  final String text;
  final bool isCorrect;

  QuizOption({required this.text, required this.isCorrect});

  factory QuizOption.fromJson(Map<String, dynamic> json) => QuizOption(
        text: json['text'] ?? '',
        isCorrect: json['is_correct'] ?? false,
      );
}

class QuizQuestion {
  final String question;
  final String theme;
  final String cadre;
  final String? acte;
  final List<QuizOption> options;

  QuizQuestion({
    required this.question,
    required this.theme,
    required this.cadre,
    this.acte,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
        question: json['question'] ?? '',
        theme: json['theme'] ?? '',
        cadre: json['cadre'] ?? '',
        acte: json['acte'],
        options: (json['options'] as List? ?? [])
            .whereType<Map>()
            .map((e) => QuizOption.fromJson(e.cast<String, dynamic>()))
            .toList(),
      );

  /// Indices des options marquées comme correctes.
  Set<int> get correctIndices => {
        for (var i = 0; i < options.length; i++)
          if (options[i].isCorrect) i
      };

  /// Vérifie si [selection] correspond exactement aux bonnes réponses.
  bool isCorrectSet(Set<int> selection) {
    final correct = correctIndices;
    return selection.length == correct.length && selection.containsAll(correct);
  }
}
