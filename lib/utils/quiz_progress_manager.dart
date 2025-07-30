import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Gère la progression et les statistiques des quiz.
class QuizProgressManager {
  QuizProgressManager._();

  static const String _statsKey = 'quiz_cadre_stats';
  static const String _countKey = 'quiz_cadre_count';

  /// Enregistre le résultat d'une question pour le [cadre] spécifié.
  static Future<void> recordQuestion(String cadre, bool correct) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_statsKey);
    final Map<String, dynamic> stats =
        jsonString != null ? jsonDecode(jsonString) as Map<String, dynamic> : {};
    final Map<String, dynamic> data =
        (stats[cadre] as Map<String, dynamic>?) ?? {'total': 0, 'correct': 0};
    data['total'] = (data['total'] as int) + 1;
    if (correct) {
      data['correct'] = (data['correct'] as int) + 1;
    }
    stats[cadre] = data;
    await prefs.setString(_statsKey, jsonEncode(stats));
  }

  /// Incrémente le compteur de quiz terminés.
  static Future<void> incrementQuizCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_countKey) ?? 0;
    await prefs.setInt(_countKey, count + 1);
  }
}

