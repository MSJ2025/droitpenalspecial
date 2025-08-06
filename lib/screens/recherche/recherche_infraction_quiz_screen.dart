import 'package:flutter/material.dart';
import '../../models/exercice_infraction.dart';
import '../../utils/infraction_suggestions.dart';

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

  @override
  void initState() {
    super.initState();
    _intitules = loadInfractionIntitules();
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
    final expected = widget.caseData.infractionsCiblees
        .map((e) => e.intitule.toLowerCase())
        .toSet();
    final provided = _selected.map((e) => e.toLowerCase()).toSet();
    final correct = expected.intersection(provided);
    final incorrect = provided.difference(expected);
    final manquantes = expected.difference(provided);
    final success =
        correct.length == expected.length && incorrect.isEmpty && manquantes.isEmpty;
    await _showResultSummary(
      success: success,
      correct: correct.length,
      incorrect: incorrect.length,
      manquantes: manquantes.length,
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
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: intitules
                      .map(
                        (i) => CheckboxListTile(
                          title: Text(i),
                          value: _selected.contains(i),
                          onChanged: (v) {
                            setState(() {
                              if (v ?? false) {
                                _selected.add(i);
                              } else {
                                _selected.remove(i);
                              }
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              ElevatedButton(onPressed: _validate, child: const Text('Valider')),
            ],
          );
        },
      ),
    );
  }
}
