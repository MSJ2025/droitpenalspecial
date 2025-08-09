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
/// [SharedPreferences]. Les données sont désormais organisées par type de
/// quiz (ex. "PP", "DPS") puis par catégorie (cadre ou thème).
class QuizProgressManager {
  QuizProgressManager._();

  static const _statsKey = 'quiz_stats';
  static const _countKey = 'quiz_count';

  /// Enregistre la réponse à une question pour un [quizType] et une
  /// [category] donnés. [isCorrect] doit être `true` si la réponse est
  /// correcte.
  static Future<void> recordQuestion(
      String quizType, String category, bool isCorrect) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_statsKey);
    final Map<String, dynamic> data =
        jsonStr != null ? json.decode(jsonStr) as Map<String, dynamic> : {};

    final Map<String, dynamic> quizData =
        (data[quizType] as Map<String, dynamic>?) ?? {};
    final Map<String, dynamic> categoryData =
        (quizData[category] as Map<String, dynamic>?) ??
            {'answered': 0, 'correct': 0};

    final stats = QuizStats.fromJson(categoryData);
    final updated = QuizStats(
      answered: stats.answered + 1,
      correct: stats.correct + (isCorrect ? 1 : 0),
    );

    quizData[category] = updated.toJson();
    data[quizType] = quizData;
    await prefs.setString(_statsKey, json.encode(data));
  }

  /// Incrémente le compteur de quiz terminés pour le [quizType] donné.
  static Future<void> incrementQuizCount(String quizType) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_countKey);
    Map<String, dynamic> data =
        jsonStr != null ? json.decode(jsonStr) as Map<String, dynamic> : {};

    final current = (data[quizType] as int?) ?? 0;
    data[quizType] = current + 1;

    await prefs.setString(_countKey, json.encode(data));
  }

  /// Retourne les statistiques pour tous les types de quiz.
  static Future<Map<String, Map<String, QuizStats>>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_statsKey);
    if (jsonStr == null) return {};
    final Map<String, dynamic> data =
        json.decode(jsonStr) as Map<String, dynamic>;
    return data.map((quizType, value) {
      final categories = value as Map<String, dynamic>;
      return MapEntry(
        quizType,
        categories.map(
            (cat, v) => MapEntry(cat, QuizStats.fromJson(v as Map<String, dynamic>))),
      );
    });
  }

  /// Retourne le nombre total de quiz réalisés. Si [quizType] est fourni,
  /// retourne uniquement le total pour ce type.
  static Future<int> getQuizCount({String? quizType}) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_countKey);
    if (jsonStr == null) return 0;
    final Map<String, dynamic> data =
        json.decode(jsonStr) as Map<String, dynamic>;
    if (quizType != null) {
      return (data[quizType] as int?) ?? 0;
    }
    return data.values
        .fold<int>(0, (sum, v) => sum + (v as int? ?? 0));
  }

  /// Réinitialise toutes les statistiques enregistrées.
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statsKey);
    await prefs.remove(_countKey);
  }
}
