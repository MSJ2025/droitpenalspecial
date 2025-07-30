import 'package:flutter/material.dart';

import '../utils/quiz_progress_manager.dart';
import '../widgets/adaptive_appbar_title.dart';

class QuizStatsScreen extends StatefulWidget {
  const QuizStatsScreen({super.key});

  @override
  State<QuizStatsScreen> createState() => _QuizStatsScreenState();
}

class _QuizStatsScreenState extends State<QuizStatsScreen> {
  Map<String, QuizStats> _stats = {};
  int _quizCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final stats = await QuizProgressManager.getStats();
    final count = await QuizProgressManager.getQuizCount();
    setState(() {
      _stats = stats;
      _quizCount = count;
      _loading = false;
    });
  }

  Future<void> _reset() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser ?'),
        content: const Text('Voulez-vous effacer toutes les statistiques ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Oui'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await QuizProgressManager.reset();
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle('Statistiques', maxLines: 1),
        actions: [
          IconButton(
            onPressed: (_stats.isEmpty && _quizCount == 0) ? null : _reset,
            icon: const Icon(Icons.delete),
            tooltip: 'Réinitialiser',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_stats.isEmpty) {
      return const Center(child: Text('Aucune statistique'));
    }

    final entries = _stats.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Quiz terminés : $_quizCount',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...entries.map((e) {
          final percent =
              e.value.answered == 0 ? 0.0 : e.value.correct / e.value.answered;
          final percentText = (percent * 100).toStringAsFixed(1);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.key,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  tween: Tween(begin: 0.0, end: percent),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(value: value);
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  '${e.value.correct} / ${e.value.answered} bonnes réponses ($percentText\u202f%)',
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
