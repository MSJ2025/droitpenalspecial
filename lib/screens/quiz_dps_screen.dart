import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../models/quiz_pp_question.dart';
import '../models/quiz_question.dart';
import '../utils/json_loader.dart';
import '../utils/quiz_progress_manager.dart';
import '../widgets/adaptive_appbar_title.dart';

class QuizDPSScreen extends StatefulWidget {
  const QuizDPSScreen({super.key});

  @override
  State<QuizDPSScreen> createState() => _QuizDPSScreenState();
}

class _QuizDPSScreenState extends State<QuizDPSScreen> {
  List<QuizPPQuestion> _questions = [];
  int _current = 0;
  int _score = 0;
  Set<int> _selectedIndices = {};
  bool _loading = true;
  bool _finished = false;
  Color? _feedbackColor;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final data = await loadJsonWithComments('assets/data/dps_questions.json');
    final Map<String, dynamic> map = json.decode(data);
    final questions = <QuizPPQuestion>[];
    map.forEach((theme, list) {
      if (list is List) {
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            final opts = item['options'] as List? ?? [];
            final correctIndex = item['correct'] as int? ?? -1;
            final propositions = [
              for (var i = 0; i < opts.length; i++)
                QuizOption(
                  text: opts[i] as String? ?? '',
                  isCorrect: i == correctIndex,
                ),
            ];
            final sourceCategorie =
                item['_source_categorie'] as String? ?? '';
            final itemTheme = item['theme'] as String? ?? '';
            questions.add(
              QuizPPQuestion(
                cadre: theme,
                acte: item['question'] as String? ?? '',
                sourceCategorie: sourceCategorie,
                theme: itemTheme,
                propositions: propositions,
              ),
            );
          }
        }
      }
    });
    questions.shuffle();
    for (final q in questions) {
      q.propositions.shuffle();
    }
    setState(() {
      _questions = questions.length > 12 ? questions.take(12).toList() : questions;
      _loading = false;
    });
  }

  Widget _buildQuestion(QuizPPQuestion question) {
    return Column(
      key: ValueKey(_current),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                question.sourceCategorie,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                question.acte,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: question.propositions.length,
            itemBuilder: (context, index) {
              final opt = question.propositions[index];
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                splashColor: Colors.grey.withOpacity(0.2),
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    if (_selectedIndices.contains(index)) {
                      _selectedIndices.remove(index);
                    } else {
                      _selectedIndices.add(index);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: _selectedIndices.contains(index)
                      ? const LinearGradient(colors: [Color(0xFF66BB6A), Color(0xFF43A047)])
                      : const LinearGradient(colors: [Color(0xFFF5F5F5), Color(0xFFFFFFFF)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          opt.text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _selectedIndices.contains(index) ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      if (_selectedIndices.contains(index))
                        const Icon(Icons.check_circle, color: Colors.white),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showResultDialog(
    bool correct,
    List<String> selectedOptions,
    List<String> correctOptions,
  ) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Gradient header remains unchanged except for colors below
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: correct
                            ? [Colors.green.shade300, Colors.green.shade100]
                            : [Colors.red.shade300, Colors.red.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      child: Center(
                        child: Text(
                          correct ? "Bonne réponse" : "Mauvaise réponse",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Replace correct answers Container with Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.3),
                            Colors.green.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        // keep existing padding and child Column here
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Réponses correctes:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (final t in correctOptions)
                              Text(
                                "• $t",
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (!correct) ...[
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.withOpacity(0.3),
                              Colors.red.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          // keep existing padding and child Column here
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Vos choix:",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              for (final s in selectedOptions)
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: correctOptions.contains(s)
                                      ? Colors.green.withOpacity(0.8)
                                      : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  child: Text(
                                    "• $s",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Continuer"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _next() async {
    if (_selectedIndices.isEmpty) return;
    final question = _questions[_current];
    final correct = question.isCorrectSet(_selectedIndices);
    if (correct) {
      _score++;
    }
    await QuizProgressManager.recordQuestion('global', correct);

    // Build correctOptions and selectedOptions lists
    final correctOptions = question.propositions
        .where((o) => o.isCorrect)
        .map((o) => o.text)
        .toList();
    final selectedOptions = _selectedIndices
        .map((i) => question.propositions[i].text)
        .toList();

    await _showResultDialog(correct, selectedOptions, correctOptions);
    if (!mounted) return;

    setState(() {
      if (_current < _questions.length - 1) {
        _current++;
        _selectedIndices = {};
      } else {
        _finished = true;
      }
    });
    if (_finished) {
      await QuizProgressManager.incrementQuizCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: const AdaptiveAppBarTitle('Quiz DPS', maxLines: 1),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_finished) {
      // Calculate percentage
      final double percentValue = _score / _questions.length;
      final String percentString = (percentValue * 100).toStringAsFixed(1);

      return Scaffold(
        appBar: AppBar(
          title: const AdaptiveAppBarTitle('Quiz DPS', maxLines: 1),
          backgroundColor: Colors.blue.shade400,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade200, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    percentValue >= 0.8
                      ? Icons.emoji_events
                      : percentValue >= 0.7
                        ? Icons.thumb_up
                        : Icons.sentiment_dissatisfied,
                    size: 72,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Quiz terminé !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: percentValue,
                          strokeWidth: 10,
                          backgroundColor: Colors.white54,
                          valueColor: AlwaysStoppedAnimation(
                            percentValue >= 0.8
                              ? Colors.greenAccent
                              : percentValue >= 0.5
                                ? Colors.amberAccent
                                : Colors.redAccent,
                          ),
                        ),
                        Center(
                          child: Text(
                            '$percentString%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade400,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Fermer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final question = _questions[_current];
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle('Quiz DPS', maxLines: 1),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final progress = (_current + 1) / _questions.length;
                return Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade400, Colors.blue.shade200],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
            SharedAxisTransition(
              child: child,
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
            ),
          child: _buildQuestion(_questions[_current]),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.white24,
                onTap: _next,
                child: const Center(
                  child: Text(
                    'Valider',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
