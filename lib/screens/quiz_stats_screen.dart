import 'package:flutter/material.dart';
import '../utils/quiz_progress_manager.dart';
import '../widgets/adaptive_appbar_title.dart';

class QuizStatsScreen extends StatelessWidget {
  const QuizStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle('Statistiques du quiz', maxLines: 1),
      ),
      body: FutureBuilder<Map<String, QuizStats>>(
        future: QuizProgressManager.loadAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final stats = snapshot.data!;
          if (stats.isEmpty) {
            return const Center(child: Text('Aucune donnée'));
          }
          final entries = stats.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key));
          return ListView(
            children: [
              for (final entry in entries)
                ListTile(
                  title: Text(entry.key),
                  subtitle: Text(
                      '${entry.value.correct} / ${entry.value.answered} réponses'),
                  trailing: Text(
                    '${entry.value.answered == 0 ? 0 : (entry.value.correct / entry.value.answered * 100).toStringAsFixed(1)} %',
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
