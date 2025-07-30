import 'package:flutter/material.dart';
import '../widgets/adaptive_appbar_title.dart';

class QuizStatsScreen extends StatelessWidget {
  const QuizStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle('Statistiques', maxLines: 1),
      ),
      body: const Center(
        child: Text('À venir'),
      ),
    );
  }
}
