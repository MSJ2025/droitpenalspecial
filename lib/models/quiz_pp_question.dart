class QuizOption {
  final String text;
  final bool isCorrect;

  QuizOption({required this.text, required this.isCorrect});

  factory QuizOption.fromJson(Map<String, dynamic> json) => QuizOption(
        text: json['text'] ?? '',
        isCorrect: json['is_correct'] ?? false,
      );
}

class QuizPPQuestion {
  final String cadre;
  final String acte;
  final List<QuizOption> propositions;

  QuizPPQuestion({
    required this.cadre,
    required this.acte,
    required this.propositions,
  });

  factory QuizPPQuestion.fromJson(Map<String, dynamic> json) => QuizPPQuestion(
        cadre: json['cadre'] ?? '',
        acte: json['acte'] ?? '',
        propositions: (json['propositions'] as List? ?? [])
            .whereType<Map>()
            .map((e) => QuizOption.fromJson(e.cast<String, dynamic>()))
            .toList(),
      );

  Set<int> get correctIndices => {
        for (var i = 0; i < propositions.length; i++)
          if (propositions[i].isCorrect) i
      };

  bool isCorrectSet(Set<int> selection) {
    final correct = correctIndices;
    return selection.length == correct.length && selection.containsAll(correct);
  }
}
