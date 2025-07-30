import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class QuizStats {
  final int answered;
  final int correct;

  QuizStats({required this.answered, required this.correct});

  factory QuizStats.fromJson(Map<String, dynamic> json) => QuizStats(
        answered: json['answered'] ?? 0,
        correct: json['correct'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'answered': answered,
        'correct': correct,
      };
}

class QuizProgressManager {
  static const _statsKey = 'quiz_stats';
  static const _completedKey = 'quiz_completed';

  static Future<Map<String, QuizStats>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_statsKey);
    if (raw == null) return {};
    final Map<String, dynamic> data = json.decode(raw);
    return data.map((key, value) => MapEntry(
          key,
          QuizStats.fromJson((value as Map).cast<String, dynamic>()),
        ));
  }

  static Future<void> saveStats(Map<String, QuizStats> stats) async {
    final prefs = await SharedPreferences.getInstance();
    final map = stats.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString(_statsKey, json.encode(map));
  }

  static Future<int> getCompletedCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_completedKey) ?? 0;
  }

  static Future<void> setCompletedCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_completedKey, count);
  }

  static Future<void> incrementCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_completedKey) ?? 0;
    await prefs.setInt(_completedKey, count + 1);
  }

  static Future<void> recordAnswer(String cadre, bool correct) async {
    final prefs = await SharedPreferences.getInstance();
    final stats = await getStats();
    final current = stats[cadre] ?? QuizStats(answered: 0, correct: 0);
    stats[cadre] = QuizStats(
      answered: current.answered + 1,
      correct: current.correct + (correct ? 1 : 0),
    );
    final map = stats.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString(_statsKey, json.encode(map));
  }
}
