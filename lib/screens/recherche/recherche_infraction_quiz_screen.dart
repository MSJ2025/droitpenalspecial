import 'package:flutter/material.dart';
import '../../models/exercice_infraction.dart';
import '../../utils/infraction_suggestions.dart';
import 'recherche_infraction_correction_screen.dart';

class RechercheInfractionQuizScreen extends StatefulWidget {
  final ExerciceInfraction caseData;
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
    _addField();
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
    required Set<String> correct,
    required Set<String> incorrect,
    required Set<String> manquantes,
  }) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(success ? 'Bravo !' : 'Raté…'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildResultCard('Infractions correctes', correct, Colors.green),
              _buildResultCard('Infractions incorrectes', incorrect, Colors.red),
              _buildResultCard('Infractions manquantes', manquantes, Colors.orange),
            ],
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

  Widget _buildResultCard(
    String title,
    Set<String> items,
    Color color,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Card(
      color: color.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title (${items.length})',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            for (final item in items)
              Text(
                item,
                style: TextStyle(color: color),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _validate() async {
    final expectedLower =
        widget.caseData.infractionsCiblees.map((e) => e.toLowerCase()).toSet();
    final providedControllers = _controllers.whereType<TextEditingController>();
    final providedOriginal = providedControllers
        .map((c) => c.text.trim())
        .where((e) => e.isNotEmpty)
        .toSet();
    final providedLower =
        providedOriginal.map((e) => e.toLowerCase()).toSet();

    final correctLower = expectedLower.intersection(providedLower);
    final incorrectLower = providedLower.difference(expectedLower);
    final manquantesLower = expectedLower.difference(providedLower);

    final correct = widget.caseData.infractionsCiblees
        .where((e) => correctLower.contains(e.toLowerCase()))
        .toSet();
    final manquantes = widget.caseData.infractionsCiblees
        .where((e) => manquantesLower.contains(e.toLowerCase()))
        .toSet();
    final incorrect = providedOriginal
        .where((e) => incorrectLower.contains(e.toLowerCase()))
        .toSet();

    final success =
        correct.length == expectedLower.length && incorrect.isEmpty && manquantes.isEmpty;
    await _showResultSummary(
      success: success,
      correct: correct,
      incorrect: incorrect,
      manquantes: manquantes,
    );
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RechercheInfractionCorrectionScreen(caseData: widget.caseData),
      ),
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
