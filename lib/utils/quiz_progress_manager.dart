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
class QuizProgressManager {
  QuizProgressManager._();

  static const _statsKey = 'quiz_stats';
  static const _countKey = 'quiz_count';

  /// Enregistre la réponse à une question pour le [cadre] donné.
  ///
  /// [isCorrect] doit être `true` si la réponse est correcte.
  static Future<void> recordQuestion(String cadre, bool isCorrect) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_statsKey);
    final Map<String, dynamic> data =
        jsonStr != null ? json.decode(jsonStr) as Map<String, dynamic> : {};

    final Map<String, dynamic> cadreData =
        (data[cadre] as Map<String, dynamic>?) ?? {'answered': 0, 'correct': 0};

    final stats = QuizStats.fromJson(cadreData);
    final updated = QuizStats(
      answered: stats.answered + 1,
      correct: stats.correct + (isCorrect ? 1 : 0),
    );

    data[cadre] = updated.toJson();
    await prefs.setString(_statsKey, json.encode(data));
  }

  /// Incrémente le compteur total de quiz terminés.
  static Future<void> incrementQuizCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_countKey) ?? 0;
    await prefs.setInt(_countKey, count + 1);
  }

  /// Retourne les statistiques pour chaque cadre.
  static Future<Map<String, QuizStats>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_statsKey);
    if (jsonStr == null) return {};
    final Map<String, dynamic> data = json.decode(jsonStr) as Map<String, dynamic>;
    return data.map((key, value) => MapEntry(
          key,
          QuizStats.fromJson(value as Map<String, dynamic>),
        ));
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
