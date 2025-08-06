import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:droitpenalspecial/models/quiz_pp_question.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('sélection aléatoire de 12 questions', () async {
    final data = await rootBundle.loadString('assets/data/quiz_pp.json');
    final list = json.decode(data) as List;
    final questions = list
        .whereType<Map>()
        .map((e) => QuizPPQuestion.fromJson(e.cast<String, dynamic>()))
        .toList();
    final shuffled = List<QuizPPQuestion>.from(questions)..shuffle();
    final selection = shuffled.length > 12 ? shuffled.take(12).toList() : shuffled;
    expect(selection.length, lessThanOrEqualTo(12));
  });

  test('évaluation des réponses', () async {
    final data = await rootBundle.loadString('assets/data/quiz_pp.json');
    final list = json.decode(data) as List;
    final question = list
        .whereType<Map>()
        .map((e) => QuizPPQuestion.fromJson(e.cast<String, dynamic>()))
        .first;
    final correct = question.correctIndices;
    expect(question.isCorrectSet(correct), isTrue);
    final incomplete = {...correct};
    if (incomplete.isNotEmpty) {
      incomplete.remove(incomplete.first);
    }
    expect(question.isCorrectSet(incomplete), isFalse);
  });
}
