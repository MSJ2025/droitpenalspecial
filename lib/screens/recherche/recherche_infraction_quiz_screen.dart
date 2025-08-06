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

  @override
  void initState() {
    super.initState();
    _intitules = loadInfractionIntitules();
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
