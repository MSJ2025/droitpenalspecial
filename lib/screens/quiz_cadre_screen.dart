import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../utils/json_loader.dart';
import '../utils/quiz_progress_manager.dart';
import '../widgets/adaptive_appbar_title.dart';

class QuizCadreScreen extends StatefulWidget {
  const QuizCadreScreen({super.key});

  @override
  State<QuizCadreScreen> createState() => _QuizCadreScreenState();
}

class _QuizCadreScreenState extends State<QuizCadreScreen> {
  List<QuizQuestion> _questions = [];
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
    final data = await loadJsonWithComments('assets/data/quiz_cadre_enquete.json');
    final List<dynamic> list = json.decode(data);
    setState(() {
      final questions = list
          .whereType<Map>()
          .map((e) => QuizQuestion.fromJson(e.cast<String, dynamic>()))
          .toList()
        ..shuffle();
      _questions =
          questions.length > 12 ? questions.take(12).toList() : questions;
      _loading = false;
    });
  }

  Widget _buildQuestion(QuizQuestion question) {
    return Column(
      key: ValueKey(_current),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question.question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: question.options.length,
            itemBuilder: (context, index) {
              final opt = question.options[index];
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

  void _next() {
    if (_selectedIndices.isEmpty) return;
    final correct = _questions[_current].isCorrectSet(_selectedIndices);
    QuizProgressManager.record(_questions[_current].cadre, correct);
    if (correct) {
      _score++;
    }

    setState(() {
      _feedbackColor = correct ? Colors.green : Colors.red;
    });

    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      if (!mounted) return;
      setState(() {
        _feedbackColor = null;
        if (_current < _questions.length - 1) {
          _current++;
          _selectedIndices = {};
        } else {
          _finished = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: const AdaptiveAppBarTitle('Quiz cadres d\'enquête', maxLines: 1),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_finished) {
      return Scaffold(
        appBar: AppBar(
          title: const AdaptiveAppBarTitle('Quiz cadres d\'enquête', maxLines: 1),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Score : \$_score / \${_questions.length}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        title: const AdaptiveAppBarTitle('Quiz cadres d\'enquête', maxLines: 1),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: _feedbackColor ?? Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_current + 1) / _questions.length,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _buildQuestion(question),
              ),
            ),
            ElevatedButton(
              onPressed: _selectedIndices.isEmpty ? null : _next,
              child: Text(
                _current < _questions.length - 1 ? 'Suivant' : 'Terminer',
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
