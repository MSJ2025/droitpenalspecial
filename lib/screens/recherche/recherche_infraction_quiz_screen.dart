import 'package:flutter/material.dart';
import '../../models/recherche_infraction.dart';
import '../../utils/infraction_suggestions.dart';

class RechercheInfractionQuizScreen extends StatefulWidget {
  final RechercheInfraction caseData;
  const RechercheInfractionQuizScreen({super.key, required this.caseData});

  @override
  State<RechercheInfractionQuizScreen> createState() => _RechercheInfractionQuizScreenState();
}

class _RechercheInfractionQuizScreenState extends State<RechercheInfractionQuizScreen> {
  final List<TextEditingController?> _controllers = [];
  late Future<List<String>> _suggestions;

  @override
  void initState() {
    super.initState();
    _suggestions = loadInfractionSuggestions();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c?.dispose();
    }
    super.dispose();
  }

  void _addField() {
    setState(() {
      _controllers.add(null);
    });
  }


  Future<void> _showResultSummary({
    required bool success,
    required int correct,
    required int incorrect,
    required int manquantes,
  }) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(success ? 'Bravo !' : 'Raté…'),
        content: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: success
                    ? [Colors.greenAccent, Colors.green]
                    : [Colors.redAccent, Colors.orange],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Correctes : $correct'),
                Text('Incorrectes : $incorrect'),
                Text('Manquantes : $manquantes'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  Future<void> _validate() async {
    final expected =
        widget.caseData.intitulesAttendus.map((e) => e.toLowerCase()).toSet();
    final provided = _controllers
        .whereType<TextEditingController>()
        .map((c) => c.text.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toSet();
    final correct = expected.intersection(provided);
    final incorrect = provided.difference(expected);
    final manquantes = expected.difference(provided);
    final success = correct.length == expected.length && incorrect.isEmpty && manquantes.isEmpty;
    await _showResultSummary(
      success: success,
      correct: correct.length,
      incorrect: incorrect.length,
      manquantes: manquantes.length,
    );
  }

  Widget _buildField(int index, List<String> suggestions) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Autocomplete<String>(
        optionsBuilder: (text) {
          if (text.text.isEmpty) return const Iterable<String>.empty();
          return suggestions.where((s) => s.toLowerCase().contains(text.text.toLowerCase()));
        },
        fieldViewBuilder: (_, controller, focusNode, onFieldSubmitted) {
          if (_controllers[index] == null) {
            _controllers[index] = controller;
          } else {
            controller = _controllers[index]!;
          }
          return TextField(
              controller: controller,
              focusNode: focusNode,
              onSubmitted: (_) => onFieldSubmitted());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trouver les infractions')),
      body: FutureBuilder<List<String>>(
        future: _suggestions,
        builder: (context, snapshot) {
          final suggestions = snapshot.data ?? const <String>[];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _controllers.length,
                    itemBuilder: (context, index) => _buildField(index, suggestions),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(onPressed: _addField, child: const Text('Ajouter')),
                    const SizedBox(width: 16),
                    ElevatedButton(onPressed: _validate, child: const Text('Valider')),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
