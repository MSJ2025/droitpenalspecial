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
  int _completed = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final stats = await QuizProgressManager.getStats();
    final completed = await QuizProgressManager.getCompletedCount();
    setState(() {
      _stats = stats;
      _completed = completed;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle('Statistiques quiz', maxLines: 1),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Quiz réalisés : $_completed'),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _stats.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final entry = _stats.entries.elementAt(index);
                      final cadre = entry.key;
                      final stats = entry.value;
                      final rate =
                          stats.answered == 0 ? 0 : stats.correct / stats.answered * 100;
                      return ListTile(
                        title: Text(cadre),
                        subtitle: Text(
                            '${stats.answered} r\u00e9ponses \u00b7 ${rate.toStringAsFixed(1)} % de r\u00e9ussite'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
