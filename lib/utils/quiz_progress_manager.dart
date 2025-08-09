import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class QuizStats {
  final int answered;
  final int correct;

  const QuizStats({required this.answered, required this.correct});

  factory QuizStats.fromJson(Map<String, dynamic> json) => QuizStats(
        answered: json['answered'] ?? 0,
        correct: json['correct'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'answered': answered,
        'correct': correct,
      };
}

/// Gère la progression des quiz en stockant les statistiques via
/// [SharedPreferences].
enum QuizType { pp, dps }

class QuizProgressManager {
  QuizProgressManager._();

  static const _statsKey = 'quiz_stats';
  static const _countKey = 'quiz_count';

  /// Enregistre la réponse à une question pour le [quiz] et la [categorie] donnés.
  ///
  /// [isCorrect] doit être `true` si la réponse est correcte.
  static Future<void> recordQuestion(String categorie, bool isCorrect,
      {required QuizType quiz}) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_statsKey);
    final Map<String, dynamic> data =
        jsonStr != null ? json.decode(jsonStr) as Map<String, dynamic> : {};

    final quizKey = quiz.name;
    final Map<String, dynamic> quizData =
        (data[quizKey] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final Map<String, dynamic> categorieData =
        (quizData[categorie] as Map<String, dynamic>?) ??
            {'answered': 0, 'correct': 0};

    final stats = QuizStats.fromJson(categorieData);
    final updated = QuizStats(
      answered: stats.answered + 1,
      correct: stats.correct + (isCorrect ? 1 : 0),
    );

    quizData[categorie] = updated.toJson();
    data[quizKey] = quizData;
    await prefs.setString(_statsKey, json.encode(data));
  }

  /// Incrémente le compteur total de quiz terminés.
  static Future<void> incrementQuizCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_countKey) ?? 0;
    await prefs.setInt(_countKey, count + 1);
  }

  /// Retourne les statistiques pour chaque quiz et catégorie.
  static Future<Map<QuizType, Map<String, QuizStats>>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_statsKey);
    if (jsonStr == null) return {};
    final Map<String, dynamic> data =
        json.decode(jsonStr) as Map<String, dynamic>;
    return data.map((key, value) {
      final type = QuizType.values.firstWhere((e) => e.name == key);
      final Map<String, QuizStats> stats =
          (value as Map<String, dynamic>).map((k, v) => MapEntry(
                k,
                QuizStats.fromJson(v as Map<String, dynamic>),
              ));
      return MapEntry(type, stats);
    });
  }

  /// Retourne le nombre total de quiz réalisés.
  static Future<int> getQuizCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_countKey) ?? 0;
  }

  /// Réinitialise toutes les statistiques enregistrées.
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statsKey);
    await prefs.remove(_countKey);
  }
}
