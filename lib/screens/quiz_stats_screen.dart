import 'package:flutter/material.dart';

import '../utils/quiz_progress_manager.dart';
import '../widgets/adaptive_appbar_title.dart';
import '../widgets/gradient_expansion_tile.dart';

class QuizStatsScreen extends StatefulWidget {
  const QuizStatsScreen({super.key});

  @override
  State<QuizStatsScreen> createState() => _QuizStatsScreenState();
}

class _QuizStatsScreenState extends State<QuizStatsScreen> {
  Map<String, QuizStats> _ppStats = {};
  Map<String, QuizStats> _dpsStats = {};
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
      _ppStats = stats[QuizType.pp] ?? {};
      _dpsStats = stats[QuizType.dps] ?? {};
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
            onPressed:
                (_ppStats.isEmpty && _dpsStats.isEmpty && _quizCount == 0)
                    ? null
                    : _reset,
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
    if (_ppStats.isEmpty && _dpsStats.isEmpty) {
      return const Center(child: Text('Aucune statistique'));
    }

    final totalAnswered = [..._ppStats.values, ..._dpsStats.values]
        .fold<int>(0, (sum, s) => sum + s.answered);
    final totalCorrect = [..._ppStats.values, ..._dpsStats.values]
        .fold<int>(0, (sum, s) => sum + s.correct);
    final percent =
        totalAnswered == 0 ? 0.0 : totalCorrect / totalAnswered;
    final percentText = (percent * 100).toStringAsFixed(1);
    final Color valueColor = percent >= 0.8
        ? Colors.green
        : percent >= 0.5
            ? Colors.amber
            : Colors.red;
    final List<Color> gradientColors = percent >= 0.8
        ? [Colors.green.shade400, Colors.green.shade200]
        : percent >= 0.5
            ? [Colors.amber.shade400, Colors.amber.shade200]
            : [Colors.red.shade400, Colors.red.shade200];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'QUIZ JOUÉS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$_quizCount',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'TOTAL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: percent),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Container(
                                width: constraints.maxWidth * value,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$totalCorrect / $totalAnswered bonnes réponses ($percentText%)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: valueColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          GradientExpansionTile(
            title: const Text("Statistiques Quiz PP (cadres d'enquêtes)"),
            children: _buildStatList(_ppStats),
          ),
          const SizedBox(height: 6),
          GradientExpansionTile(
            title: const Text('Statistiques Quiz DPS (thèmes)'),
            children: _buildStatList(_dpsStats),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStatList(Map<String, QuizStats> stats) {
    if (stats.isEmpty) {
      return const [ListTile(title: Text('Aucune statistique'))];
    }
    return stats.entries.map((e) {
      final answered = e.value.answered;
      final correct = e.value.correct;
      final percent = answered == 0 ? 0.0 : correct / answered;
      final percentText = (percent * 100).toStringAsFixed(1);
      return ListTile(
        title: Text(e.key),
        trailing: Text('$correct/$answered ($percentText%)'),
      );
    }).toList();
  }
}
