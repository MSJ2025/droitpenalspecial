import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../utils/json_loader.dart';
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
  int _selected = -1;
  bool _loading = true;
  bool _finished = false;

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
                child: RadioListTile<int>(
                  value: index,
                  groupValue: _selected,
                  onChanged: (v) {
                    setState(() {
                      _selected = v ?? -1;
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
    if (_selected == -1) return;
    if (_questions[_current].isCorrect(_selected)) {
      _score++;
    }
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
        _selected = -1;
      });
    } else {
      setState(() {
        _finished = true;
      });
    }
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
      body: Padding(
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
              onPressed: _selected == -1 ? null : _next,
              child: Text(
                _current < _questions.length - 1 ? 'Suivant' : 'Terminer',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
