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

class _RechercheInfractionQuizScreenState
    extends State<RechercheInfractionQuizScreen> {
  final Set<String> _selected = <String>{};
  late Future<List<String>> _intitules;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _intitules = loadInfractionIntitules();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _validate() async {
    final expected = widget.caseData.infractionsCiblees
        .map((e) => e.intitule.toLowerCase())
        .toSet();
    final provided = _selected.map((e) => e.toLowerCase()).toSet();
    final correct = expected.intersection(provided);
    final incorrect = provided.difference(expected);
    final manquantes = expected.difference(provided);
    final success =
        correct.length == expected.length && incorrect.isEmpty && manquantes.isEmpty;

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RechercheInfractionResultScreen(
          caseData: widget.caseData,
          correct: correct.length,
          incorrect: incorrect.length,
          manquantes: manquantes.length,
          success: success,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trouver les infractions')),
      body: FutureBuilder<List<String>>(
        future: _intitules,
        builder: (context, snapshot) {
          final intitules = snapshot.data ?? const <String>[];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    final query = textEditingValue.text.trim().toLowerCase();
                    if (query.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return intitules.where((i) =>
                        i.toLowerCase().contains(query) && !_selected.contains(i));
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    _textController = controller;
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onSubmitted: (_) => onFieldSubmitted(),
                      decoration: const InputDecoration(
                        labelText: 'Ajouter une infraction',
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                  onSelected: (selection) {
                    setState(() {
                      _selected.add(selection);
                    });
                    _textController.clear();
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selected
                          .map(
                            (s) => Chip(
                              label: Text(s),
                              onDeleted: () {
                                setState(() {
                                  _selected.remove(s);
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: _validate, child: const Text('Valider')),
              ],
            ),
          );
        },
      ),
    );
  }
}
