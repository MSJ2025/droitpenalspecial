import 'package:flutter/material.dart';

import '../utils/quiz_progress_manager.dart';
import '../widgets/adaptive_appbar_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizStatsScreen extends StatefulWidget {
  const QuizStatsScreen({super.key});

  @override
  State<QuizStatsScreen> createState() => _QuizStatsScreenState();
}

class _QuizStatsScreenState extends State<QuizStatsScreen> {
  Map<String, Map<String, QuizStats>> _stats = {};
  int _quizCount = 0;
  bool _loading = true;
  bool _ppExpanded = true;
  bool _dpsExpanded = true;

  @override
  void initState() {
    super.initState();
    _load();
    _loadExpansionState();
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

  Future<void> _loadExpansionState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ppExpanded = prefs.getBool('stats_pp_expanded') ?? true;
      _dpsExpanded = prefs.getBool('stats_dps_expanded') ?? true;
    });
  }

  Future<void> _saveExpansionState(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle('Statistiques', maxLines: 1),
        actions: [
          IconButton(
            onPressed:
                (_stats.isEmpty || _stats.values.every((m) => m.isEmpty)) &&
                        _quizCount == 0
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
    if (_stats.isEmpty || _stats.values.every((m) => m.isEmpty)) {
      return const Center(child: Text('Aucune statistique'));
    }

    final totalAnswered = _stats.values.fold<int>(
        0, (sum, m) => sum + m.values.fold<int>(0, (s, st) => s + st.answered));
    final totalCorrect = _stats.values.fold<int>(
        0, (sum, m) => sum + m.values.fold<int>(0, (s, st) => s + st.correct));
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

    final ppEntries = _stats.entries
        .where((e) => _isPP(e.key))
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final dpsEntries = _stats.entries
        .where((e) => !_isPP(e.key))
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

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
          if (ppEntries.isNotEmpty)
            _buildExpansion(
              'Procédure pénale',
              ppEntries,
              _ppExpanded,
              (v) {
                setState(() => _ppExpanded = v);
                _saveExpansionState('stats_pp_expanded', v);
              },
            ),
          if (dpsEntries.isNotEmpty)
            _buildExpansion(
              'Droit pénal spécial',
              dpsEntries,
              _dpsExpanded,
              (v) {
                setState(() => _dpsExpanded = v);
                _saveExpansionState('stats_dps_expanded', v);
              },
            ),
        ],
      ),
    );
  }

  bool _isPP(String key) => key.toUpperCase() == key;

  Widget _buildExpansion(
    String title,
    List<MapEntry<String, QuizStats>> entries,
    bool expanded,
    ValueChanged<bool> onExpansionChanged,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: expanded,
        onExpansionChanged: onExpansionChanged,
        children: [
          for (final e in entries)
            ListTile(
              title: Text(e.key),
              trailing: Text('${e.value.correct} / ${e.value.answered}'),
            ),
        ],
      ),
    );
  }
}
