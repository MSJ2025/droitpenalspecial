import 'quiz_question.dart';

class QuizPPQuestion {
  final String cadre;
  final String acte;
  final String theme;
  final String sourceCategorie;
  final List<QuizOption> propositions;

  QuizPPQuestion({
    required this.cadre,
    required this.acte,
    required this.propositions,
    this.theme = '',
    this.sourceCategorie = '',
  });

  factory QuizPPQuestion.fromJson(Map<String, dynamic> json) => QuizPPQuestion(
        cadre: json['cadre'] ?? '',
        acte: json['acte'] ?? '',
        theme: json['theme'] ?? '',
        sourceCategorie: json['_source_categorie'] ?? '',
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
