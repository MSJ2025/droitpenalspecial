import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/quiz_pp_question.dart';
import '../utils/json_loader.dart';
import '../utils/quiz_progress_manager.dart';
import '../widgets/adaptive_appbar_title.dart';

class QuizPPScreen extends StatefulWidget {
  const QuizPPScreen({super.key});

  @override
  State<QuizPPScreen> createState() => _QuizPPScreenState();
}

class _QuizPPScreenState extends State<QuizPPScreen> {
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
    final data = await loadJsonWithComments('assets/data/quiz_pp.json');
    final List<dynamic> list = json.decode(data);
    setState(() {
      final questions = list
          .whereType<Map>()
          .map((e) => QuizPPQuestion.fromJson(e.cast<String, dynamic>()))
          .toList()
        ..shuffle();
      _questions = questions.length > 12 ? questions.take(12).toList() : questions;
      _loading = false;
    });
  }

  Widget _buildQuestion(QuizPPQuestion question) {
    return Column(
      key: ValueKey(_current),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Cadre : ${question.cadre}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Acte : ${question.acte}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: question.propositions.length,
            itemBuilder: (context, index) {
              final opt = question.propositions[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: CheckboxListTile(
                  value: _selectedIndices.contains(index),
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        _selectedIndices.add(index);
                      } else {
                        _selectedIndices.remove(index);
                      }
                    });
                  },
                  title: Text(opt.text),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showWrongAnswerDialog(List<String> correctOptions) async {
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
              child: AlertDialog(
                title: Row(
                  children: const [
                    Icon(Icons.close, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(child: Text('Bonne(s) réponse(s)')),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    for (final t in correctOptions) Text('• $t'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
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
    await QuizProgressManager.recordQuestion(question.cadre, correct);

    setState(() {
      _feedbackColor = correct ? Colors.green : Colors.red;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    if (!correct) {
      final correctOptions = question.propositions
          .where((o) => o.isCorrect)
          .map((o) => o.text)
          .toList();
      await _showWrongAnswerDialog(correctOptions);
      if (!mounted) return;
    }

    setState(() {
      _feedbackColor = null;
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
          title: const AdaptiveAppBarTitle('Quiz PP', maxLines: 1),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_finished) {
      return Scaffold(
        appBar: AppBar(
          title: const AdaptiveAppBarTitle('Quiz PP', maxLines: 1),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) {
                  final percent = (_score / _questions.length * 100).toStringAsFixed(1);
                  return Text(
                    'Score : $_score / ${_questions.length} ($percent\u202f%)',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fermer'),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_current];
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle('Quiz PP', maxLines: 1),
      ),
      body: Container(
        color: _feedbackColor,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Padding(
            key: ValueKey(_current),
            padding: const EdgeInsets.all(16),
            child: _buildQuestion(question),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _next,
        child: const Icon(Icons.check),
      ),
    );
  }
}

