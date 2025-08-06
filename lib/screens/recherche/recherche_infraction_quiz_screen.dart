import 'package:flutter/material.dart';
import '../../models/exercice_infraction.dart';
import '../../utils/infraction_suggestions.dart';
import 'recherche_infraction_result_screen.dart';

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

  Future<void> _validate() async {
    final expectedMap = {
      for (final inf in widget.caseData.infractionsCiblees)
        inf.intitule.toLowerCase(): inf.intitule
    };
    final providedMap = {
      for (final c in _controllers.whereType<TextEditingController>())
        c.text.trim().toLowerCase(): c.text.trim()
    };
    providedMap.removeWhere((key, value) => key.isEmpty);

    final correctKeys = expectedMap.keys.toSet().intersection(providedMap.keys.toSet());
    final correct = [for (final k in correctKeys) expectedMap[k]!];
    final incorrectKeys = providedMap.keys.toSet().difference(expectedMap.keys.toSet());
    final incorrect = [for (final k in incorrectKeys) providedMap[k]!];

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RechercheInfractionResultScreen(
          caseData: widget.caseData,
          correct: correct,
          incorrect: incorrect,
        ),
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
