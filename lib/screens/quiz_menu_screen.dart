import 'package:flutter/material.dart';
import '../widgets/adaptive_appbar_title.dart';
import 'quiz_cadre_screen.dart';
import 'quiz_stats_screen.dart';

class QuizMenuScreen extends StatelessWidget {
  const QuizMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle('Quiz', maxLines: 1),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const QuizCadreScreen(),
                    ),
                  );
                },
                child: const Text('Quiz cadres d\'enquête'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('À venir')),
                  );
                },
                child: const Text('Quiz infractions'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const QuizStatsScreen(),
                    ),
                  );
                },
                child: const Text('Statistiques'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
