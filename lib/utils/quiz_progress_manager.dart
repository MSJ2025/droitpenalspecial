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

/// Gère la progression du quiz pour chaque cadre.
class QuizProgressManager {
  static const String _key = 'quiz_progress';

  /// Enregistre une réponse pour le [cadre].
  static Future<void> record(String cadre, bool isCorrect) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    Map<String, dynamic> data = {};
    if (jsonStr != null) {
      try {
        data = json.decode(jsonStr) as Map<String, dynamic>;
      } catch (_) {
        data = {};
      }
    }

    final raw = data[cadre];
    int answered = 0;
    int correct = 0;
    if (raw is Map) {
      answered = (raw['answered'] as num?)?.toInt() ?? 0;
      correct = (raw['correct'] as num?)?.toInt() ?? 0;
    }
    answered++;
    if (isCorrect) correct++;

    data[cadre] = {'answered': answered, 'correct': correct};
    await prefs.setString(_key, json.encode(data));
  }

  /// Charge toutes les statistiques enregistrées.
  static Future<Map<String, QuizStats>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return {};
    try {
      final Map<String, dynamic> raw = json.decode(jsonStr) as Map<String, dynamic>;
      return raw.map((key, value) {
        if (value is Map<String, dynamic>) {
          return MapEntry(key, QuizStats.fromJson(value));
        }
        return MapEntry(key, const QuizStats(answered: 0, correct: 0));
      });
    } catch (_) {
      return {};
    }
  }
}
